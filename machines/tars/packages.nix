{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    chromium
    commit-mono
    open-sans
  ];
}
