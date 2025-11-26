{
  config,
  ...
}:
{
  services.minecraft-server = {
    enable = true;
    eula = true;
    openFirewall = true; # Port 25565
    declarative = true;
    package = vanilla-1-8;
    serverProperties = {
      gamemode = 0;
      difficulty = 3;
      allow-cheats = false;
      max-players = 10;
      motd = "Classic Minecraft";
    };
    jvmOpts = "-Xms4G -Xmx8G";
  };
}
