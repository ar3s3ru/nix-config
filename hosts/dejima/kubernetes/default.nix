{ pkgs, config, ... }:

{
  # Add the necessary packages for the Kubernetes experience.
  environment.systemPackages = with pkgs; [
    k3s
    k9s # To have a better experience
    openssl # Used to generate user account CSRs.
    kubectl
    kubernetes-helm
    docker
    runc
  ];

  # Must have containerd enabled to run containers on Kubernetes.
  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;

  # NOTE: this is only necessary to be used in case of emergencies, when the Tailnet
  # is down and can't be reached again.
  #
  # You can connect to the k8s cluster through the VPN hostname and port 6443.
  # Remember to use `insecure-skip-tls-verify: true` to make it work.
  networking.firewall.interfaces."ens3".allowedTCPPorts = [ 6443 ];

  security.acme.certs."ar3s3ru.dev".extraDomainNames = [
    "k8s.dejima.ar3s3ru.dev"
  ];

  services.nginx.virtualHosts."k8s.dejima.ar3s3ru.dev" = {
    onlySSL = true;
    useACMEHost = "ar3s3ru.dev";

    locations."/" = {
      proxyPass = "https://localhost:6443";
      proxyWebsockets = true;
    };
  };

  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # Kubernetes through K3S.
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = "--tls-san=k8s.dejima.ar3s3ru.dev";
  };

  systemd.services."k3s-apply-patches" =
    let
      manifestsDir = "/var/lib/rancher/k3s/server/manifests";
      patchTraefikPorts = ./patch-traefik-ports.yaml;
    in
    {
      enable = config.services.k3s.enable;
      description = "Apply patches to the K3S installation.";

      wantedBy = [ "multi-user.target" ];
      wants = [ "k3s.service" ];
      before = [ "k3s.service" ];
      reloadTriggers = [ patchTraefikPorts ];

      serviceConfig.Type = "oneshot";

      script = ''
        mkdir -p ${manifestsDir}
        ln -sf ${patchTraefikPorts} ${manifestsDir}/patch-traefik-ports.yaml
      '';
    };

  # systemd.services."k3s-create-cluster-admin" = {
  #   enable = config.services.k3s.enable;
  #   description = "Create the cluster-admin service account for managing through Terraform";

  #   wantedBy = [ "multi-user.target" ];
  #   wants = [ "k3s.service" ];
  #   after = [ "k3s.service" ];

  #   serviceConfig.Type = "oneshot";

  #   script =
  #     let
  #       kubectl = "KUBECONFIG=/etc/rancher/k3s/k3s.yaml ${pkgs.kubectl}/bin/kubectl";
  #       clusterAdminTokenManifest = ./secret-cluster-admin-token.yaml;
  #     in
  #     ''
  #       ${kubectl} create serviceaccount cluster-admin --namespace kube-system
  #       ${kubectl} create clusterrolebinding cluster-admin-manual --clusterrole=cluster-admin --serviceaccount=kube-system:cluster-admin
  #       ${kubectl} apply -f ${clusterAdminTokenManifest}
  #     '';
  # };
}
