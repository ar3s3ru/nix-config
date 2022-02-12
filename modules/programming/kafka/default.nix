{ config, pkgs, lib, ... }:
let
  kafkactl = pkgs.callPackage ./kafkactl.nix { };
in
{
  home.packages = with pkgs; [
    kafkactl
  ];

  programs.fish.shellAliases = {
    kfc = "${kafkactl}/bin/kafkactl";
  };

  xdg.configFile."kafkactl/config.yml".text = /* yml */ ''
    contexts:
      default:
        brokers:
        - localhost:9092
    current-context: default
  '';
}
