{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../common/system.nix
    ./../../programs/chromium.nix
    ./../../services/gnome.nix
    ./../../services/tailscale.nix
  ];

  networking.hostName = "tars";
}
