{ vars, ... }:
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
    hostId = vars.hostIds.case;
  };

  services.zfsAutoSync = {
    enable = true;
    remoteHost = vars.sync.remoteHost;
    remoteDataset = vars.sync.remoteDataset;
    localPrefix = vars.sync.localPrefix;
  };

  services.openssh.knownHosts.${vars.sync.remoteHost} = {
    hostNames = [ vars.sync.remoteHost ];
    publicKey = vars.sync.publicKey;
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
