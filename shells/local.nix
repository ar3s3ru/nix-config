{ unixtools
, gnumake
, terraform
, terragrunt
, nil
, mkShell
}:

mkShell {
  name = "default";
  packages = [
    # Nice utilities.
    unixtools.watch
    gnumake

    # Relevant packages to apply the configurations.
    terraform
    terragrunt

    # Linters
    nil
  ];
}
