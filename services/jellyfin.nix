{ config, pkgs, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  systemd.tmpfiles.rules = [
    "d /media 0770 - media - -"
  ];

  users.groups.media = { };
}
