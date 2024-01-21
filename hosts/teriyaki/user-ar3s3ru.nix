{ config, lib, pkgs, inputs, ... }:
let
  font = "MesloLGSDZ Nerd Font";
in
{
  imports = [
    ../../home/ar3s3ru
    ./gpg-darwin.nix
    ./yabai.nix
  ];

  programs.alacritty.settings.font.normal.family = font;

  programs.vscode.userSettings = {
    "editor.fontFamily" = lib.mkForce "'${font}'";
    "editor.fontSize" = 12;
  };

  home.packages = with pkgs; [
    nodejs
    nodejs.pkgs.pnpm
  ];
}
