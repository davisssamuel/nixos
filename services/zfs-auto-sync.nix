{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zfsAutoSync;

  zfsSyncScript = pkgs.writeShellApplication {
    name = "zfs-auto-sync";
    runtimeInputs = [
      pkgs.zfs
      pkgs.openssh
    ];
    text = ''
      set -euo pipefail
      REMOTE_USER="${cfg.remoteUser}"
      REMOTE_HOST="${cfg.remoteHost}"
      DATASET_REMOTE="${cfg.remoteDataset}"
      DATASET_LOCAL="${cfg.localPrefix}/''${REMOTE_HOST}/${cfg.remoteDataset}"
                                    
      LATEST_REMOTE=$(ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs list -t snapshot -o name -s creation -H -d1 "$DATASET_REMOTE" | tail -1)

      if ! zfs list "$DATASET_LOCAL" >/dev/null 2>&1; then
      echo "No local dataset yet, doing full initial recursive send"
      ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs send -R "$LATEST_REMOTE" | zfs recv -F -d "${cfg.localPrefix}/''${REMOTE_HOST}"
      exit 0
      fi

      LATEST_LOCAL_SNAP=$(zfs list -t snapshot -o name -s creation -H -d1 "$DATASET_LOCAL" | tail -1 | sed 's/.*@/@/')
      BASE="''${LATEST_REMOTE%@*}$LATEST_LOCAL_SNAP"

      if [ "$BASE" = "$LATEST_REMOTE" ]; then
      echo "Already up to date"
      exit 0
      fi

      ssh "$REMOTE_USER"@"$REMOTE_HOST" zfs send -R -i "$BASE" "$LATEST_REMOTE" | zfs recv -F -d "${cfg.localPrefix}/''${REMOTE_HOST}"
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
