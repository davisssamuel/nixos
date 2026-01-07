{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../common/system.nix
    ./../../services/tailscale.nix
  ];

  networking.hostName = "tars";
}
