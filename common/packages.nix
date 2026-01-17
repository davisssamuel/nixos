{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    fzf
    gcc
    git
    htop
    lua-language-server
    neovim
    nixd
    nixfmt-classic
    shfmt
    stow
    stylua
    tree
    vim
    wget
  ];
}
