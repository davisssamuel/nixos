{ config, pkgs, vars, ... }:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "bb45604a-1292-447a-a349-d619f43b798" = {
        credentialsFile = "/home/${vars.username}/.cloudflared/bb45604a-1292-447a-a349-d619f43b798f.json";
        default = "http_status:404";
        ingress = {
          "jellyfin.davisssamuel.net" = {
            service = "http://localhost:8096";
          };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [
    cloudflared
  ];
}
