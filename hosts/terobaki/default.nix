{ nixpkgs, nixos-hardware, home-manager, ... }@inputs:
let
in
nixpkgs.lib.nixosSystem {
  system = "aarch64-linux";
  modules = [
    home-manager.nixosModules.home-manager
    ../modules/latest-linux-kernel.nix
    ../modules/nix-unstable.nix
    ../modules/nixpkgs.nix
    ../modules/fish.nix
    ../modules/openssh.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./tailscale.nix
    ./qemu-guest.nix
  ];
}
