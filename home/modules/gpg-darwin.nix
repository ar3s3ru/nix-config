{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    pinentry
    pinentry_mac
  ];
}
