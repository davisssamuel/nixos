{
  config,
  pkgs,
  vars,
  ...
}:
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

  systemd.tmpfiles.rules = [
    "d /media 2770 ${vars.username} jellyfin - -"
  ];

  users.users.${vars.username} = {
    extraGroups = [ "jellyfin" ];
  };
}
