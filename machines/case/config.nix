{ ... }:
{
  imports = [
    ./hardware.nix
    ./../../common/system.nix
    ./../../services/cloudflared.nix
    ./../../services/headscale.nix
    ./../../services/tailscale.nix
  ];

  networking = {
    hostName = "case";
    hostId = "";
  };

  # https://wiki.nixos.org/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "26.05";
}
