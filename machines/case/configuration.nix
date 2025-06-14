{
  inputs,
  outputs,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ./../../common/system.nix

    ./../../services/tailscale.nix
    ./../../services/cloudflared.nix
    ./../../services/jellyfin.nix
  ];

  networking.hostName = "case";
}
