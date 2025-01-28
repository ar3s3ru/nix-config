{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    jetbrains.idea-ultimate
    maven
  ];

  programs.java.enable = true;
  programs.java.package = pkgs.jdk23;

  environment.variables."JAVA_HOME" = "${config.programs.java.package}/lib/openjdk";
}
