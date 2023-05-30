{ config, pkgs, lib, ... }:

{
  imports = [
    ./kafka
    ./go.nix
    ./rust.nix
  ];

  home.packages = with pkgs; [
    docker-compose
    python
    protobuf
    bazelisk
  ];

  # TODO: re-enable me for non-aarch64-linux
  programs.java = {
    enable = lib.mkDefault true;
    package = lib.mkDefault pkgs.openjdk11;
  };
}