{ nixpkgs, nixos-hardware, home-manager, disko, nix-colors, nur, ... }:
let
  nur-overlay = {
    nixpkgs.overlays = [ nur.overlay ];
  };
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.lenovo-thinkpad-t14
    nixos-hardware.nixosModules.common-cpu-intel
    home-manager.nixosModules.home-manager
    disko.nixosModules.disko
    nur-overlay
    ../../derivations/overlay.nix
    ../modules/latest-linux-kernel.nix
    ../modules/nix-unstable.nix
    ../modules/nixpkgs.nix
    ../modules/fish.nix
    ../modules/power-management.nix
    ../modules/bluetooth.nix
    ../modules/neovim.nix
    ../modules/gpg.nix
    ../modules/firewall.nix
    ../modules/openssh.nix
    ../modules/ios.nix
    ../modules/user-default.nix
    ./configuration.nix
    ./disko.nix
  ];
}
