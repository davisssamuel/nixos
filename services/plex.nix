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
    "d /media 0755 root media -"
    "Z /media/movies 0755 root media -"
    "Z /media/shows 0755 root media -"
  ];
}
