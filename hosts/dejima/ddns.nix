{ lib, pkgs, ... }:
let
  mkCloudflareDdnsSerivce = pkgs.callPackage ../modules/services/mk-cloudflare-ddns.nix { };
in
{
  systemd.services."ddns-dejima.ar3s3ru.dev" = mkCloudflareDdnsSerivce {
    domain = "dejima.ar3s3ru.dev";
    proxied = "false";
    token = lib.readFile ../../secrets/cloudflare-token-ar3s3ru.dev;
  };
}
