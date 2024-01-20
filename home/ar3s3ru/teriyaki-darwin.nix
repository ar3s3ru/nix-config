{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./default.nix
    ../modules/yabai.nix
    ../modules/gpg-darwin.nix
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
  xdg.configFile."gh/hosts.yml".source = ../../hosts/momonoke/secrets/gh_hosts.yml;

  home.packages = with pkgs; [
    nodejs
    nodejs.pkgs.pnpm
  ];
}

