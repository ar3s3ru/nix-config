{ pkgs, ... }:

pkgs.mkShell
{
  name = "default";

  packages = with pkgs; [
    # Nice utilities.
    unixtools.watch
    gnumake

    # Relevant packages to apply the configurations.
    terraform
    terragrunt
  ];
}
