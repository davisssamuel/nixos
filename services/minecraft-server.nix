{
  config,
  pkgs,
  ...
}:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Port 25565
    declarative = true;

    package = pkgs.minecraftServers.vanilla-1-8;

    serverProperties = {
      gamemode = "survival";
      difficulty = "hard";
      allow-cheats = false;
      level-type = "minecraft:large_biomes";
      max-players = 10;
      player-idle-timeout = 120;
      motd = "Classic Minecraft";
    };

    jvmOpts = "-Xms4G -Xmx8G -XX:+UseG1GC";
  };
}
