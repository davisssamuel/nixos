{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../common/system.nix
    ./../../services/cloudflared.nix
    ./../../services/headscale.nix
    ./../../services/tailscale.nix
  ];

  networking.hostName = "tars";
}
