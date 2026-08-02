{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
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
