{ lib, pkgs, ... }:
let
  mkCloudflareDdnsSerivce = pkgs.callPackage ../modules/services/mk-cloudflare-ddns.nix { };
in
{
  systemd.services."ddns-momonoke.ar3s3ru.dev" = mkCloudflareDdnsSerivce {
    domain = "momonoke.ar3s3ru.dev";
    proxied = "false";
    token = lib.readFile ../../secrets/cloudflare-token-ar3s3ru.dev;
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
