{ nixpkgs, nixos-hardware, disko, ... }:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    disko.nixosModules.disko
    ../../derivations/overlay.nix
    ../modules/latest-linux-kernel.nix
    ../modules/nix-unstable.nix
    ../modules/nixpkgs.nix
    ../modules/fish.nix
    ../modules/power-management.nix
    ../modules/neovim.nix
    ../modules/bluetooth.nix
    ../modules/gpg.nix
    ../modules/firewall.nix
    ../modules/openssh.nix
    ../modules/user-default.nix
    ../modules/tmux.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./disko.nix
    ./tailscale.nix
    ./nvidia.nix
    ./group-media.nix
    ./direnv.nix
    ./kubernetes.nix
  ];
}
