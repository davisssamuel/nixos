{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ cockpit ];

  services.cockpit = {
    enable = true;
    port = 9090;
    openFirewall = true;
    settings = {
      WebService = {
        AllowUnencrypted = true;
      };
    };
    allowed-origins = [
      "http://100.99.70.29:9090"
      "http://192.168.200.235:9090"
      "https://case.local"
    ];
  };
}
