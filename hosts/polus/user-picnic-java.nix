{ ... }:

{
  programs.fish.shellAliases = {
    mvnc = "mvn --batch-mode --define surefire.timeout=300 --define rabbitmq.support-delays=false -Dstyle.color=always --settings ./picnic-shared-tools/settings.xml -Prelaxed-release\\$";
    mvni = "mvnc install";
  };
}
