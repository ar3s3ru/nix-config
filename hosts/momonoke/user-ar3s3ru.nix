{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ../../home/ar3s3ru
    # ../../home/modules/sway
    # ../../home/modules/firefox.nix
    # ../../home/modules/gtk.nix
    ../../home/modules/gpg-linux.nix
    # ../../home/modules/fonts.nix
    # ../../home/modules/slack.nix
    # ../../home/modules/vscode.nix
  ];

  programs.alacritty.settings.font = {
    size = 10;
    normal.family = "MesloLGS NF";
  };

  programs.vscode.userSettings = {
    "editor.fontFamily" = lib.mkForce "'MesloLGS NF'";
    "editor.fontSize" = 14;
  };

  home.packages = with pkgs; [
    # tdesktop # Telegrm desktop app.
    # imagemagick
  ];

  # Enable mpv hardware acceleration.
  # programs.fish.shellAliases = {
  #   mpv = "mpv --hwdec=vaapi --gpu-context=wayland";
  # };
}
