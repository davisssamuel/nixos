{ config, inputs, lib, pkgs, ... }:

{
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    boot.loader = {
        systemd-boot = {
            enable = true;
            configurationLimit = 5;
        };
	efi.canTouchEfiVariables = true;
    };

    swapDevices = [{
    	device = "/swapfile";
        size = 16 * 1024;
    }];

    hardware.graphics.enable = true;

    networking = {
        hostName = "case";
        networkmanager.enable = true;
        firewall.enable = true;
        # firewall.allowedTCPPorts = [];
        # firewall.allowedUDPPorts = [];
    };

    time.timeZone = "America/New_York";
    i18n.defaultLocale = "en_US.UTF-8";

    services = {
        openssh.enable = true;
        tailscale.enable = true;
    };

    environment.systemPackages = with pkgs; [
	    curl
        git
	    jellyfin
        tree
        unzip
        vim
        wget
        zip
    ];

    programs.zsh = {
        enable = true;
        autosuggestions.enable = true;
    };

    users.users.sam = {
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "docker" ];
        shell = pkgs.zsh;
        packages = with pkgs; [
		fzf
		neovim
		ripgrep
		stow
        ];
    };
}
