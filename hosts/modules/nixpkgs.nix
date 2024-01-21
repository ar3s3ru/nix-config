{ ... }:

{
  nixpkgs.config.allowUnfree = true;
  # Python 2.7 is marked as insecure. Fix.
  nixpkgs.config.permittedInsecurePackages = [
    "python-2.7.18.7"
  ];
}
