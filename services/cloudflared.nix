{
  pkgs,
  vars,
  config,
  ...
}:
let
  hostName = config.networking.hostName;
  tunnelId = vars.tunnelIds.${hostName};
in
{
  services.cloudflared = {
    enable = true;
    tunnels = {
      "${tunnelId}" = {
        credentialsFile = "/root/.cloudflared/${tunnelId}.json";
        default = "http_status:404";
        ingress = {
          # "jellyfin.davisssamuel.net" = {
          #   service = "http://localhost:8096";
          # };
          # "watch.davisssamuel.net" = {
          #   service = "http://localhost:8096";
          # };
        };
      };
    };
  };

  environment.systemPackages = with pkgs; [ cloudflared ];
}
