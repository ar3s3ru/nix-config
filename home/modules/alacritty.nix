{ config, pkgs, lib, profile, colorscheme, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };

      window.opacity = lib.mkDefault 0.9;

      font = {
        size = lib.mkDefault 12;
        normal.family = lib.mkDefault "Terminus";
      };

      colors = with colorscheme; {
        primary = {
          background = "0x${colors.base00}";
          foreground = "0x${colors.base05}";
        };

        cursor = {
          text = "0x${colors.base00}";
          cursor = "0x${colors.base05}";
        };

        normal = {
          black = "0x${colors.base00}";
          red = "0x${colors.base08}";
          green = "0x${colors.base0B}";
          yellow = "0x${colors.base0A}";
          blue = "0x${colors.base0D}";
          magenta = "0x${colors.base0E}";
          cyan = "0x${colors.base0C}";
          white = "0x${colors.base05}";
        };

        # Bright colors
        bright = {
          black = "0x${colors.base03}";
          red = "0x${colors.base08}";
          green = "0x${colors.base0B}";
          yellow = "0x${colors.base0A}";
          blue = "0x${colors.base0D}";
          magenta = "0x${colors.base0E}";
          cyan = "0x${colors.base0C}";
          white = "0x${colors.base07}";
        };
      };
    };
  };
}
