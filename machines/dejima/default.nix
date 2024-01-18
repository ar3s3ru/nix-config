{ nixpkgs, nixos-hardware, disko, ... }:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.common-cpu-intel
    disko.nixosModules.disko
    ../../derivations/overlay.nix
    ../modules/latest-linux-kernel.nix
    ../modules/nix-unstable.nix
    ../modules/fish.nix
    ../modules/power-management.nix
    ../modules/podman.nix
    ../modules/neovim.nix
    ../modules/bluetooth.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./disko.nix
    ./ddns.nix
    ./tailscale.nix
  ];
}
