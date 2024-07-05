{ unixtools
, gnumake
, terraform
, terragrunt
, nil
, kubectl
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

    # Temporarily for Kubernetes
    kubectl
  ];
}
