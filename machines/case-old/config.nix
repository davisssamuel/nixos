{ ... }:
{
  imports = [
    ./hardware.nix
    ./../../common/system.nix
    ./../../services/cloudflared.nix
    ./../../services/jellyfin.nix
    ./../../services/minecraft-server.nix
    ./../../services/raspberry-flavoured-server.nix
    ./../../services/tailscale.nix
  ];

  networking.hostName = "case";
}
