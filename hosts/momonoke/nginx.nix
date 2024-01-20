{ lib, pkgs, config, ... }:
let
  mkCloudflareDdnsSerivce = pkgs.callPackage ../../services/mk-cloudflare-ddns.nix { };
in
{
  systemd.services."ddns-momonoke.ar3s3ru.dev" = mkCloudflareDdnsSerivce {
    domain = "momonoke.ar3s3ru.dev";
    proxied = "false";
    token = lib.readFile ../../secrets/cloudflare-token-ar3s3ru.dev;
  };
}
