{ ... }:
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
    hostId = "ff328b24";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
