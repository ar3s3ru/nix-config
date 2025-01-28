{ pkgs, ... }:

{
  home.packages = with pkgs; [
    just # picnic-fca uses that for some projects.
    libxml2 # For xmllint.
    xmlstarlet
  ];
}
