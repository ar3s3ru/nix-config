{ nixpkgs, nixos-hardware, disko, ... }:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-intel
    disko.nixosModules.disko
    ../modules/bluetooth.nix
    ../modules/direnv.nix
    ../modules/firewall.nix
    ../modules/fish.nix
    ../modules/gpg.nix
    ../modules/latest-linux-kernel.nix
    ../modules/neovim.nix
    ../modules/nix-unstable.nix
    ../modules/nixpkgs.nix
    ../modules/openssh.nix
    ../modules/power-management.nix
    ../modules/tmux.nix
    ../modules/user-default.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./disko.nix
    ./tailscale.nix
    ./kubernetes.nix
  ];
}
