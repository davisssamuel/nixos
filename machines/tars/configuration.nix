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
  ];

  networking.hostName = "tars";
}
