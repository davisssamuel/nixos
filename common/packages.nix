{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    tree
    vim
    wget
  ];
}
