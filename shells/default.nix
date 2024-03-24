{ flake-utils, nixpkgs, ... }:

flake-utils.lib.eachDefaultSystem
  (system:
  let
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    devShells.default = pkgs.callPackage ./local.nix { };
  })
