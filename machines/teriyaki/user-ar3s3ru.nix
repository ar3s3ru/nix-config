{ config, lib, pkgs, inputs, ... }:
let
  font = "MesloLGSDZ Nerd Font";
in
{
  imports = [
    ../../home/modules/yabai.nix
    ../../home/modules/gpg-darwin.nix
    ../../home/ar3s3ru
  ];

  programs.alacritty.settings.font = {
    size = 14;
    normal.family = font;
  };

  programs.vscode.userSettings = {
    "editor.fontFamily" = lib.mkForce "'${font}'";
    "editor.fontSize" = 14;
  };

  # Using manual config for gh, programs.gh does not really support auth in a nice way.
  xdg.configFile."gh/hosts.yml".source = ../../machines/momonoke/secrets/gh_hosts.yml;

  home.packages = with pkgs; [
    nodejs
    nodejs.pkgs.pnpm
  ];
}
