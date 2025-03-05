{ lib, ... }:

{
  imports = [
    ../../home/ar3s3ru
    ../../home/modules/gpg-linux.nix
  ];

  programs.alacritty.settings.font = {
    size = 10;
    normal.family = "MesloLGS NF";
  };

  programs.vscode.profiles.default.userSettings = {
    "editor.fontFamily" = lib.mkForce "'MesloLGS NF'";
    "editor.fontSize" = 14;
  };
}
