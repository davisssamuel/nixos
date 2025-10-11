{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    stow
    tree
    vim
    wget
  ];
}
