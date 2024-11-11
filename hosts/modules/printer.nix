{ ... }:

{
  # Enable printer discovery through Avahi
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Enable CUPS for printing documents.
  services.printing = {
    enable = true;
  };
}
