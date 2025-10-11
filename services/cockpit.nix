{
  config,
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    cockpit
  ];

  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
  };
}
