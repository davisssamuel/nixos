{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./../../common/system.nix

    ./../../services/cloudflared.nix
    ./../../services/jellyfin.nix
    ./../../services/minecraft-server.nix
    ./../../services/tailscale.nix
  ];

  environment.systemPackages = with pkgs; [
    fzf
    gcc
    lua-language-server
    neovim
    nixd
    stow
    stylua
  ];

  networking.hostName = "case";
}
