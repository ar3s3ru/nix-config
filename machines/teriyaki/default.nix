{ darwin, home-manager, nix-colors, ... }@inputs:
let
  nixpkgs = import inputs.nixpkgs {
    config.allowUnfree = true;
    config.allowUnsupportedSystem = true;
    config.allowBroken = true;
  };
in
darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  inputs = { inherit darwin nixpkgs; };
  modules = [
    home-manager.darwinModules.home-manager
    nix-colors.homeManagerModule
    ../../home/config.nix
    ./configuration.nix
    ./user-ar3s3ru.nix
  ];
}
