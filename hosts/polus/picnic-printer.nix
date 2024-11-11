{ pkgs, ... }:

{
  # Canon ImageRunner
  # Source: https://picnic.atlassian.net/wiki/spaces/SYSA/pages/3807643103/Linux+How+to+add+the+Canon+ImageRunner+and+setup+the+secure+print
  services.printing.drivers = with pkgs; [
    canon-cups-ufr2
  ];
}
