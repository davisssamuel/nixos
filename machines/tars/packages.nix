{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alacritty
    cargo
    rustc
    zed-editor
  ];

  fonts.packages = with pkgs; [
    fira-code
    fira-code-symbols
    liberation_ttf
    nerd-fonts.commit-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    noto-fonts-lgc-plus
  ];
}
