{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./../../common/system.nix

    ./../../services/tailscale.nix
  ];

  environment.systemPackages = with pkgs; [
    fzf
    gcc
    lua-language-server
    neovim
    nixd
    nixfmt-classic
    stow
    stylua
  ];

  networking.hostName = "tars";
}
