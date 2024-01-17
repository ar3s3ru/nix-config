{ pkgs, config, ... }:
let
  acmeCertDirectory = config.security.acme.certs."flugg.app".directory;
in
{
  environment.systemPackages = with pkgs; [
    k3s
    openssl # Used to generate user account CSRs.
    helm
  ];

  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = ''
      --disable traefik
    '';
  };

  # Add local registry support within the Kubernetes cluster.
  environment.etc."rancher/k3s/registries.yaml" = {
    text = ''
      mirrors:
        registry.flugg.app:
          endpoint:
            - "http://localhost:${toString config.services.dockerRegistry.port}"
    '';
  };
}
