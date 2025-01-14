{
  nixpkgs.overlays = [
    (final: prev: {
      cloudflare-ddns = prev.callPackage ./cloudflare-ddns.nix { };
      headscale-alpha = prev.callPackage ./headscale-alpha.nix { };
    })
  ];
}
