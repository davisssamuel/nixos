{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bash-language-server
    fzf
    lua-language-server
    neovim
    nixd
    nixfmt
    shfmt
    stylua
    tree-sitter
    nil
  ];
}
