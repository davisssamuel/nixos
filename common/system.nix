{
  inputs,
  config,
  pkgs,
  vars,
  ...
}:

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

  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 5;
    };
    efi.canTouchEfiVariables = true;
    timeout = 10;
  };

  fileSystems."/".options = [ "noatime" ];

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024;
    }
  ];

  users.users.${vars.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "jellyfin"
    ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      vars.sshPublicKeyMacbook
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
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

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
