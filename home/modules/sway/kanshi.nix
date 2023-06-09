{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;

    profiles."home".outputs = [
      {
        criteria = "eDP-1";
        scale = 1.0;
      }
      {
        criteria = "LG Electronics LG HDR 4K 211MAHUMY369";
        scale = 1.25;
      }
    ];
  };
}
