{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
	cargo
    curl
    gcc
    git
    htop
	rustc
    stow
    tree
    vim
    wget
  ];
}
