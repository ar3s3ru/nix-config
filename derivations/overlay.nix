{ ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      cloudflare-ddns = prev.callPackage ./cloudflare-ddns.nix { };
      headscale-alpha = prev.callPackage ./headscale-alpha.nix { };
    })
    # Python packages
    (final: prev: {
      pythonPackagesOverlays = (prev.pythonPackagesOverlays or [ ]) ++ [
        (python-final: python-prev: {
          idasen_ha = python-final.callPackage ./idasen-ha.nix { };
        })
      ];

      python3 =
        let
          self = prev.python3.override {
            inherit self;
            packageOverrides = prev.lib.composeManyExtensions final.pythonPackagesOverlays;
          };
        in
        self;

      python3Packages = final.python3.pkgs;
    })
  ];
}
