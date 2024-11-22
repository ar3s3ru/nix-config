{ unixtools
, gnumake
, git
, terraform
, terragrunt
, nil
, kubectl
, k9s
, mkShell
}:

mkShell {
  name = "default";
  packages = [
    # Nice utilities.
    git
    unixtools.watch
    gnumake

    # Relevant packages to apply the configurations.
    terraform
    terragrunt

    # Linters
    nil

    # Temporarily for Kubernetes
    kubectl
    k9s
  ];
}
