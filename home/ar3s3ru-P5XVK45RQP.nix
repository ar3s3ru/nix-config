{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./ar3s3ru.nix
    ./modules/chronomics.nix
    ./modules/yabai.nix
    ./modules/gpg-darwin.nix
    ./modules/vscode.nix
  ];

  programs.alacritty.settings.font = {
    size = 14;
    normal.family = "MesloLGSDZ Nerd Font";
  };

  programs.vscode.userSettings = {
    "editor.fontFamily" = lib.mkForce "'MesloLGSDZ Nerd Font'";
    "editor.fontSize" = 14;
  };

  # Using manual config for gh, programs.gh does not really support auth in a nice way.
  xdg.configFile."gh/hosts.yml".source = ../machines/P5XVK45RQP/secrets/gh_hosts.yml;
}
