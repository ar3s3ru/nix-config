{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    pinentry-gnome
  ];

  # NOTE: GTK+3 is not working well for some reason...
  # Swithcing back to GTK+2 for the time being.
  # pinentryFlavor = "gnome3";
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "gtk2";
}
