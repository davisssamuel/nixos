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

  users.users.plex.extraGroups = [ "media" ];

  systemd.tmpfiles.rules = [
    #    "d /var/lib/plex 0755 plex plex -"
    "d /media 0755 root media -"
    "Z /media/movies 0755 root media -"
    "Z /media/shows 0755 root media -"
  ];
}
