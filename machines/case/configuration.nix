{
  inputs,
  outputs,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix

    ./../../core/base.nix

    ./../../services/tailscale.nix
    ./../../services/cloudflared.nix
    ./../../services/jellyfin.nix
  ];

  networking.hostName = "case";
}
