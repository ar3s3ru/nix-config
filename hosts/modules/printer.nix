{ pkgs, ... }:

{
  # Enable printer discovery through Avahi
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Enable CUPS for printing documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ ];
  };
}
