{ config, pkgs, libs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # nerdfonts
    # noto-fonts
    # noto-fonts-cjk
    # noto-fonts-emoji
    terminus-nerdfont
    terminus_font
    terminus_font_ttf
    papirus-icon-theme
    font-awesome

    # Use a font viewer to check that shit is working properly.
    gnome.gnome-font-viewer
  ];
}
