{ config, ... }:

{
  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "danilocianfr+letsencrypt@gmail.com";
      group = config.services.nginx.group;
      dnsProvider = "cloudflare";
      environmentFile = "/var/lib/acme/environment"; # NOTE: this file must be added manually!
      dnsPropagationCheck = true;
      extraLegoFlags = [ "--dns.resolvers=8.8.8.8:53" ];
    };

    certs."ar3s3ru.dev" = {
      dnsPropagationCheck = false;
    };
  };

  services.nginx = {
    enable = true;

    # Recommended settings
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    # Only allow PFS-enabled ciphers with AES256
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
  };
}
