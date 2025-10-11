{
  config,
  pkgs,
  vars,
  ...
}:
{
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/var/lib/plex";
    user = "plex";
    group = "plex";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  systemd.tmpfiles.rules = [
    #    "d /var/lib/plex 0755 plex plex -"
    "d /media 2770 ${vars.username} plex plex -"
    "f /media/* 0664 plex plex -"
  ];
}
