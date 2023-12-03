{ pkgs, ... }:
let
  cloudflare_ddns = pkgs.callPackage ../../derivations/cloudflare-ddns.nix { };
in
{
  home.packages = [
    cloudflare_ddns
  ];
}
