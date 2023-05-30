# User configurations that are specific for the momonoke host.

{ config, lib, pkgs, inputs, ... }:

{
  # Necessary for some external packages.
  nixpkgs.overlays = [
    inputs.nur.overlay
  ];

  imports = [
    ./ar3s3ru.nix
    ./modules/sway
    ./modules/firefox.nix
    ./modules/gtk.nix
    ./modules/gpg-linux.nix
    ./modules/fonts.nix
    ./modules/slack.nix
    ./modules/vscode.nix
  ];

  programs.alacritty.settings.font = {
    size = 10;
    normal.family = "MesloLGS NF";
  };

  programs.vscode.userSettings = {
    "editor.fontFamily" = lib.mkForce "'MesloLGS NF'";
    "editor.fontSize" = 14;
  };

  # Using manual config for gh, programs.gh does not really support auth in a nice way.
  xdg.configFile."gh/hosts.yml".source = ../machines/momonoke/secrets/gh_hosts.yml;

  home.packages = with pkgs; [
    tdesktop # Telegrm desktop app.
    imagemagick
  ];

  # Enable mpv hardware acceleration.
  programs.fish.shellAliases = {
    mpv = "mpv --hwdec=vaapi --gpu-context=wayland";
  };
}