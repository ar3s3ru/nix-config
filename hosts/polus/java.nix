{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-community-bin
    maven
  ];

  programs.java.enable = true;
  programs.java.package = pkgs.jdk21;

  environment.variables."JAVA_HOME" = "${config.programs.java.package}/lib/openjdk";
}
