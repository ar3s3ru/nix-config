{ pkgs, lib, ... }:

{
  imports = [
    ../../home/ar3s3ru
    ../../home/modules/sway
    ../../home/modules/waybar
    ../../home/modules/gammastep.nix
    ../../home/modules/kanshi.nix
    ../../home/modules/mako.nix
    ../../home/modules/rofi.nix
    ../../home/modules/xdg-desktop-portal.nix
    ../../home/modules/gtk.nix
    ../../home/modules/gpg-linux.nix
    ../../home/modules/firefox.nix
    ../../home/modules/fonts.nix
    ../../home/modules/slack.nix
    ./user-picnic-java.nix
    ./user-picnic-python.nix
  ];

  home.packages = with pkgs; [
    telegram-desktop
  ];

  programs.alacritty.settings.font = {
    size = 10;
    normal.family = "MesloLGS NF";
  };

  programs.vscode.userSettings = {
    "editor.fontFamily" = lib.mkForce "'MesloLGS NF'";
    "editor.fontSize" = 14;
  };
}
