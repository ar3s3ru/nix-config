{ config, pkgs, lib, ... }:

{
  system.stateVersion = lib.mkDefault "23.05";
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      wget
      ripgrep
      # NOTE: git is also set up in Home Manager, but I'm keeping it here
      # so that I can also clone stuff without having a configured user
      # necessarily.
      git
      git-crypt
      gopass
      gopass-jsonapi
      gnumake
      killall
      plantuml
      graphviz
      unzip
    ];
  };
}
