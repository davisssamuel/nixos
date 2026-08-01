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

<<<<<<< HEAD
      prefixes = [ "100.64.0.0/10" ];
=======
      prefixes = "100.64.0.0/10";
>>>>>>> abaa026 (fix: reverted flake to 25.11 and fixed config issues with headscale)
    };
  };
}
