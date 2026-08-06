{ vars, ... }:
{

  imports = [ ./packages.nix ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
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

  boot.zfs.forceImportRoot = true;

  fileSystems."/".options = [ "noatime" ];

  users.users.${vars.users.sam.username} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPassword = vars.users.sam.hashedPassword;
    openssh.authorizedKeys.keys = [ vars.users.sam.macbookPublicKey ];
  };

  # programs.zsh = {
  #   enable = true;
  #   autosuggestions.enable = true;
  # };

  services.openssh = {
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
    openFirewall = true;
  };

  services.fstrim.enable = true;

  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
}
