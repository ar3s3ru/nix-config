{
  nixpkgs.overlays = [
    (final: prev: {
      headscale-alpha = prev.callPackage ./headscale-alpha.nix { };
    })
  ];
}
