{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      cloudflare-ddns = prev.callPackage ./cloudflare-ddns.nix { };
    })
  ];
}
