{ nixpkgs, nixos-hardware, disko, ... }:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.common-cpu-intel
    disko.nixosModules.disko
    ../../derivations/overlay.nix
    ../modules/kernel.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./disko.nix
  ];
}
