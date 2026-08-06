{ vars, ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../core/system.nix
    ./../../services/tailscale.nix
    ./../../services/zfs-auto-snapshot.nix
  ];

  networking = {
    hostName = "tars";
    hostId = vars.hosts.tars.hostId;
  };

  boot.zfs.forceImportRoot = true;

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
