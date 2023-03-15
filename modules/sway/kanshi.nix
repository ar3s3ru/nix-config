{ config, pkgs, ... }:

{
  services.kanshi = {
    enable = true;

    profiles."default" = {
      outputs = [
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

    profiles."home" = {
      outputs = [
        {
          criteria = "eDP-1";
          scale = 1.0;
          position = "0,720";
        }
        {
          criteria = "Dell Inc. DELL U2518D 3C4YP8BH263L";
          position = "1920,0";
        }
        {
          criteria = "Dell Inc. DELL U2417H 5K9YD69I866S";
          position = "4480,0";
        }
      ];
    };
  };
}
