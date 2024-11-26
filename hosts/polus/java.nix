{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-community-bin
    maven
  ];

  programs.java.enable = true;
  programs.java.package = pkgs.jdk21;
}
