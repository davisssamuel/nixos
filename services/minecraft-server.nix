{ pkgs, ... }:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Port 25565
    declarative = true;

    package = pkgs.minecraftServers.vanilla-1-8;

    serverProperties = {
      gamemode = "survival";
      difficulty = "normal";
      allow-cheats = false;
      level-type = "minecraft:large_biomes";
      server-ip = "0.0.0.0";
      max-players = 10;
      player-idle-timeout = 120;
      motd = "Classic Minecraft";
    };

    jvmOpts = "-Xmx4G -XX:+UseG1GC -XX:MaxGCPauseMillis=50";
  };
}
