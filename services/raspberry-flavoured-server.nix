{ vars, ... }:
{
  virtualisation.docker.enable = true;

  virtualisation.oci-containers = {
    backend = "docker";
    containers.raspberry-flavoured = {
      image = "itzg/minecraft-server";
      ports = [ "25566:25565" ];
      volumes = [ "/srv/minecraft/raspberry:/data" ];
      environment = {
        EULA = "TRUE";
        TYPE = "FORGE";
        VERSION = "1.19.2";
        PACKWIZ_URL = "https://asphodel.cc/packwiz/Ports/Curse/Raspberry-Server/pack.toml";
      };
      extraOptions = [ "--restart=unless-stopped" ];
    };
  };

  users.users.${vars.username} = {
    extraGroups = [ "docker" ];
  };
}
