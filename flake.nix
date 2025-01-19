{
  description = "Dani's NixOS system configuration flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    flake-utils.url = "github:numtide/flake-utils";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nix-colors.url = "github:misterio77/nix-colors";

    darwin.url = "github:lnl7/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-apple-silicon.url = "github:tpwrules/nixos-apple-silicon";
    nixos-apple-silicon.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-utils, nixpkgs, ... }: {
    nixosConfigurations = {
      momonoke = import ./hosts/momonoke inputs;
      dejima = import ./hosts/dejima inputs;
      polus = import ./hosts/polus inputs;
      terobaki = import ./hosts/terobaki inputs;
    };

    darwinConfigurations = {
      teriyaki = import ./hosts/teriyaki inputs;
    };
  } // (flake-utils.lib.eachDefaultSystem
    (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = with pkgs; mkShell {
          name = "default";
          packages = [
            git
            unixtools.watch
            gnumake
            nil
          ];
        };
      }));
}
