{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../common/system.nix
    ./../../services/tailscale.nix
  ];

  networking = {
    hostName = "tars";
    hostId = "ff328b24";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
