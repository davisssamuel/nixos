{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../core/system.nix
    ./../../services/tailscale.nix
  ];

  networking = {
    hostName = "case";
    hostId = "0ae92de1";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
