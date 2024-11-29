{ pkgs, ... }:

{
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  wayland.windowManager.sway.extraConfig = ''
    exec ${pkgs.swaynotificationcenter}/bin/swaync
  '';
}
