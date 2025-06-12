{ config, inputs, lib, pkgs, ... }:

{
	# imports = [ 
	#     ./hardware-configuration.nix
	# ];

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

    hardware = {
        graphics.enable = true;
        # bluetooth = {
        #     enable = true;
        #     powerOnBoot = true;
        # };
    };
    
    networking = {
        networkmanager.enable = true;
        hostName = "case";
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
			tmux
			tpm
        ];
    };
    
    # system.stateVersion = "24.11";
}
