{ config, pkgs, vars, ... }:
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
  users.users.${vars.username}= {
    extraGroups = [ "media" ];
  };

}
