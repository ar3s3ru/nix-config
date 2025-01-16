{ nixpkgs, nixos-hardware, home-manager, disko, nix-colors, nur, ... }@inputs:
let
  nur-overlay = {
    nixpkgs.overlays = [
      nur.overlays.default
    ];
  };
in
nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  modules = [
    nixos-hardware.nixosModules.lenovo-thinkpad-x270
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
    ../modules/nginx.nix
    ../modules/user-default.nix
    ../modules/tmux.nix
    ./hardware-configuration.nix
    ./configuration.nix
    ./ddns.nix
    ./disable-docked-sleep.nix
    ./tailscale.nix
    ./kubernetes.nix
    ./jellyfin.nix
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.ar3s3ru = import ./user-ar3s3ru.nix;

      home-manager.extraSpecialArgs.inputs = inputs;
      home-manager.extraSpecialArgs.colorscheme = nix-colors.colorSchemes.monokai;
      home-manager.extraSpecialArgs.wallpaper = ../../wallpapers/majelletta.jpg;
      home-manager.extraSpecialArgs.ssh.private-key = ./secrets/id_ed25519;
      home-manager.extraSpecialArgs.ssh.public-key = ./id_ed25519.pub;
    }
  ];
}
