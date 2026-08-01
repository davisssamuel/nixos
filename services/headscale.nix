{ ... }:
{
  services.headscale = {
    enable = true;

    settings = {
      server_url = "https://headscale.kyncayd.com";

      dns = {
        magic_dns = true;
        base_domain = "tailnet.kyncayd.com";
      };

      prefixes = [
        "100.64.0.0/10";
      ];
    };
  };
}
