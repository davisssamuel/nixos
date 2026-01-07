{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    corefonts
    alacritty
    chromium
    commit-mono
  ];
}
