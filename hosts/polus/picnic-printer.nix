{ pkgs, ... }:

{
  # Canon ImageRunner
  # Source: https://picnic.atlassian.net/wiki/spaces/SYSA/pages/3807643103/Linux+How+to+add+the+Canon+ImageRunner+and+setup+the+secure+print
  services.printing.drivers = with pkgs; [
    gutenprint
    canon-cups-ufr2
  ];

  hardware.printers.ensurePrinters = [
    {
      name = "Picnic_MK17_Canon_ImageRunner";
      location = "MK17_Floor_3rd";
      deviceUri = "socket://172.19.12.10";
      model = "gutenprint.5.3://canon-ir_c3100/expert";
      ppdOptions = {
        Pagesize = "A4";
      };
    }
  ];
}
