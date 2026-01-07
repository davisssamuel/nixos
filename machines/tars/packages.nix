{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    chromium
    commit-mono
    corefonts
    noto-fonts
    noto-fonts-lgc-plus
  ];
}
