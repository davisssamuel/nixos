{ ... }: {
  services.headscale = {
    enable = true;

    settings = {
      server_url = "https://headscale.kyncayd.com";

      dns = {
        magic_dns = true;
        base_domain = "tailnet.kyncayd.com";
		nameservers.global = [ "1.1.1.1" "1.0.0.1" ];
      };

      prefixes.v4 = "100.64.0.0/10";
    };
  };
}
