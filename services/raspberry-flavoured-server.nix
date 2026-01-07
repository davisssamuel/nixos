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
        MEMORY = "4G";
        JVM_OPTS = "-XX:+UseG1GC -XX:MaxGCPauseMillis=50";
      };
    };
  };

  users.users.${vars.username} = {
    extraGroups = [ "docker" ];
  };
}
