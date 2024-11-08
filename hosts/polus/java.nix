{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-community-bin
    jdk # Should be OpenJDK 21
    maven
  ];
}
