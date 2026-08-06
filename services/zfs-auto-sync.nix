{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zfsAutoSync;

  excludeGrep = lib.concatMapStringsSep "|" (ds: "^${cfg.remoteDataset}/${ds}\$") cfg.excludeDatasets;

  zfsSyncScript = pkgs.writeShellApplication {
    name = "zfs-auto-sync";
    runtimeInputs = [
      pkgs.zfs
      pkgs.openssh
      pkgs.ripgrep
    ];
    text = ''
      set -euo pipefail

      REMOTE_USER="${cfg.remoteUser}"
      REMOTE_HOST="${cfg.remoteHost}"
      DATASET_REMOTE="${cfg.remoteDataset}"
      LOCAL_BASE="${cfg.localPrefix}/''${REMOTE_HOST}"

      CHILDREN=$(ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs list -H -o name -r -d1 "$DATASET_REMOTE" \
          | rg -v "^$DATASET_REMOTE\$" \
          ${lib.optionalString (cfg.excludeDatasets != [ ]) ''| rg -v "${excludeGrep}"''})

      for CHILD in $CHILDREN; do
          CHILD_REL="''${CHILD#"$DATASET_REMOTE"/}"
          DATASET_LOCAL="$LOCAL_BASE/$CHILD_REL"
          LATEST_REMOTE=$(ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs list -t snapshot -o name -s creation -H -d1 "$CHILD" | tail -1)

          if [ -z "$LATEST_REMOTE" ]; then
              echo "No snapshots yet on $CHILD, skipping"
              continue
          fi

          if ! zfs list "$DATASET_LOCAL" >/dev/null 2>&1; then
              echo "No local dataset for $CHILD yet, doing full initial recursive send"
              ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs send -R "$LATEST_REMOTE" | zfs recv -F -d "$LOCAL_BASE"
              continue
          fi

          LATEST_LOCAL_SNAP=$(zfs list -t snapshot -o name -s creation -H -d1 "$DATASET_LOCAL" | tail -1 | sed 's/.*@/@/')
          BASE="''${LATEST_REMOTE%@*}$LATEST_LOCAL_SNAP"

          if [ "$BASE" = "$LATEST_REMOTE" ]; then
              echo "$CHILD already up to date"
              continue
          fi

          ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs send -R -i "$BASE" "$LATEST_REMOTE" | zfs recv -F -d "$LOCAL_BASE"
      done
    '';
  };
in
{
  options.services.zfsAutoSync = {
    enable = lib.mkEnableOption "ZFS auto-sync from a remote host";

    remoteUser = lib.mkOption {
      type = lib.types.str;
      default = "root";
      description = "User to ssh as on the remote host for zfs send.";
    };

    remoteHost = lib.mkOption {
      type = lib.types.str;
      example = "john";
      description = "Hostname of the remote machine to pull snapshots from.";
    };

    remoteDataset = lib.mkOption {
      type = lib.types.str;
      example = "rpool";
      description = "Dataset on the remote host to recursively replicate.";
    };

    excludeDatasets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "nix" ];
      description = "List of child datasets to be excluded in backup.";
    };

    localPrefix = lib.mkOption {
      type = lib.types.str;
      default = "backup";
      description = "Local pool/prefix to receive backups into.";
    };

    interval = lib.mkOption {
      type = lib.types.str;
      default = "hourly";
      description = "systemd OnCalendar expression for sync frequency.";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.zfs-auto-sync = {
      description = "ZFS auto-sync from ${cfg.remoteHost}";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${zfsSyncScript}/bin/zfs-auto-sync";
        User = "root";
      };
    };

    systemd.timers.zfs-auto-sync = {
      description = "Timer for zfs-auto-sync (${cfg.remoteHost})";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = cfg.interval;
        Persistent = true;
        RandomizedDelaySec = "60";
      };
    };
  };
}
