{ pkgs, vars, ... }:
{

  imports = [ ./packages.nix ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  fileSystems."/".options = [ "noatime" ];

  # users.users.${vars.username} = {
  #   isNormalUser = true;
  #   extraGroups = [
  #     "wheel"
  #     "networkmanager"
  #   ];
  #   shell = pkgs.zsh;
  #   openssh.authorizedKeys.keys = [
  #     vars.macbookPublicKey
  #   ];
  # };

  # programs.zsh = {
  #   enable = true;
  #   autosuggestions.enable = true;
  # };

  users.users.root = {
    openssh.authorizedKeys.keys = [
      vars.macbookPublicKey
    ];
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = false;
      };
      openFirewall = true;
    };

    fstrim.enable = true;
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
