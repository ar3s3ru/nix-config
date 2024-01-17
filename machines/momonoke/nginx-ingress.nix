{ lib, pkgs, config, ... }:
let
  mkCloudflareDdnsSerivce = pkgs.callPackage ../../services/mk-cloudflare-ddns.nix { };
in
{
  systemd.services."ddns-momonoke.ar3s3ru.dev" = mkCloudflareDdnsSerivce {
    domain = "momonoke.ar3s3ru.dev";
    proxied = "false";
    token = lib.readFile ./secrets/cloudflare-token-ar3s3ru.dev;
  };

  # Open firewall to HTTP, HTTPS and SSH.
  networking.firewall = {
    enable = true;

    # Let's be specific that the connections can only come in through Ethernet.
    interfaces."enp0s31f6" = {
      allowedTCPPorts = [ 20 80 443 ];
    };
  };

  environment.etc."acme/environment-vars".source = ./secrets/acme-environment-vars;

  # Set up Let's Encrypt for self-signed certificats.
  security.acme = {
    acceptTerms = true;

    defaults = {
      email = "danilocianfr+letsencrypt@gmail.com";
      dnsProvider = "cloudflare";
      environmentFile = "/etc/acme/environment-vars";
      dnsPropagationCheck = true;
    };
  };

  # Reverse ingress proxy to coordinate different services.
  services.nginx = {
    enable = true;

    commonHttpConfig = ''
      log_format myformat '$remote_addr - $remote_user [$time_local] '
                          '"$request" $status $body_bytes_sent '
                          '"$http_referer" "$http_user_agent"';
    '';

    virtualHosts."momonoke.ar3s3ru.dev" = {
      forceSSL = true;
      enableACME = true;

      locations."/" = {
        return = "200 \"These are not the drones you're LOOKING for!\"";
      };
    };
  };
}
