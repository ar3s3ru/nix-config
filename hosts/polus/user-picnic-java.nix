{ lib, ... }:
let
  nexusPassword = lib.strings.fileContents ./secrets/nexus-password;
in
{
  programs.fish.shellAliases = {
    mvnc = "mvn --batch-mode --define surefire.timeout=300 --define rabbitmq.support-delays=false -Dstyle.color=always --settings ./picnic-shared-tools/settings.xml -Prelaxed-release\\$";
    mvni = "mvnc install";
  };

  home.sessionVariables."NEXUS_USERNAME" = "dcianfrone";
  home.sessionVariables."NEXUS_PASSWORD" = nexusPassword;

  home.file."maven-config" = {
    executable = false;
    target = ".m2/settings.xml";
    source = ./secrets/picnic-maven-settings.xml;
  };
}
