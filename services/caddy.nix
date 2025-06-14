{ config, ... }:
{
  services.caddy = {
    enable = true;
    virtualHosts."jellyfin.davisssamuel.net".extraConfig = ''
      reverse_proxy 127.0.0.1:8096
    '';
  };
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];
}
