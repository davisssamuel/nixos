{ ... }:
{
  imports = [
    ./hardware.nix
    ./packages.nix
    ./../../core/system.nix
    ./../../services/tailscale.nix
    ./../../services/zfs-auto-sync.nix
  ];

  networking = {
    hostName = "case";
    hostId = "0ae92de1";
  };

  services.zfsAutoSync = {
    enable = true;
    remoteHost = "tars";
    remoteDataset = "rpool";
    localPrefix = "rpool/backup";
  };

  services.openssh.knownHosts.tars = {
    hostNames = [ "tars" ];
    publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN3FwNyKNKzSMxBotGcIyg8vPJ4Y53CUBdTBWoZ9wMbq";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
