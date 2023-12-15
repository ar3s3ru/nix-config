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

  virtualisation.containerd.enable = true;

  services.dockerRegistry = {
    enable = true;
    port = 5000;
    enableDelete = true;
  };

  services.nginx.virtualHosts."registry.flugg.app" = {
    onlySSL = true;

    # NOTE: the certificates are coming from the ACME security service
    # set up in nginx-ingress.nix.
    sslCertificate = "${acmeCertDirectory}/fullchain.pem";
    sslCertificateKey = "${acmeCertDirectory}/key.pem";
    sslTrustedCertificate = "${acmeCertDirectory}/chain.pem";

    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.dockerRegistry.port}";
    };
  };

  services.headscale.settings.dns_config.extra_records = [
    {
      name = "registry.flugg.app";
      type = "A";
      value = "100.64.0.1"; # NOTE: this should be the address of this node.
    }
  ];

  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = ''
      --disable traefik
      --tls-san k8s.prod.flugg.app
    '';
  };

  # Add local registry support within the Kubernetes cluster.
  environment.etc."rancher/k3s/registries.yaml" = {
    text = ''
      mirrors:
        docker.io:
          endpoint:
            - "http://registry.flugg.app"
        registry.flugg.app:
          endpoint:
            - "http://localhost:${toString config.services.dockerRegistry.port}"
    '';
  };
}
