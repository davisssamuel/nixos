{ pkgs, vars, ... }:
{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  users.users.${vars.username} = {
    extraGroups = [ "jellyfin" ];
  };

  systemd.tmpfiles.rules = [ "d /media 2770 ${vars.username} jellyfin - -" ];
}
