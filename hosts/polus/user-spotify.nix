{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ncspot
    spotify-tui
  ];

  services.spotifyd.enable = true;
}
