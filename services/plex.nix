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
  };

  # environment.systemPackages = with pkgs; [
  #   jellyfin
  #   jellyfin-web
  #   jellyfin-ffmpeg
  # ];

  systemd.tmpfiles.rules = [
    "d /media 2770 ${vars.username} plex - -"
  ];
}
