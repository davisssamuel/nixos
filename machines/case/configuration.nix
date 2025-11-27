{
  inputs,
  outputs,
  pkgs,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ./../../common/system.nix

    ./../../services/cloudflared.nix
    ./../../services/jellyfin.nix
    ./../../services/minecraft-server.nix
    ./../../services/tailscale.nix
  ];

  networking.hostName = "case";

  environment.systemPackages = with pkgs; [
	fzf
	helix
	lua-language-server
    neovim
    nixd
		stylua
  ];
}
