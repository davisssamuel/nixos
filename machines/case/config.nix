{ ... }:
{
  imports = [
    ./hardware.nix
    ./../../common/system.nix
    ./../../services/cloudflared.nix
    # ./../../services/headscale.nix
    ./../../services/tailscale.nix
  ];

  networking.hostName = "case";
}
