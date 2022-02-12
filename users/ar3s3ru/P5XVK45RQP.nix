{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./default.nix
    ../../modules/chronomics.nix
    ../../modules/yabai.nix
    ../../modules/gpg-darwin.nix
  ];

  programs.alacritty.settings.font = {
    size = 14;
    normal.family = "MesloLGSDZ Nerd Font";
  };

  # Using manual config for gh, programs.gh does not really support auth in a nice way.
  xdg.configFile."gh/hosts.yml".source = ../../machines/P5XVK45RQP/secrets/github/gh_hosts.yml;
}
