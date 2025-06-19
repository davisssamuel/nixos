{
  config,
  pkgs,
  vars,
  ...
}:
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "${vars.caseTunnelId}" = {
        credentialsFile = "/home/${vars.username}/.cloudflared/${vars.caseTunnelId}.json";
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
