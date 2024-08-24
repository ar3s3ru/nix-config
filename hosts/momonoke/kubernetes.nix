{ pkgs, ... }:
let
  kubernetesHostname = "k8s.momonoke.ar3s3ru.dev";
in
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
    lsof # To inspect the number of open files.
  ];

  # Increase the number of open files to help with Kubernetes shenanigans,
  # like log collection and so on.
  systemd.services."user@1000".serviceConfig.LimitNOFILE = "188898";
  security.pam.loginLimits = [
    { domain = "*"; item = "nofile"; type = "-"; value = "188898"; }
    { domain = "*"; item = "memlock"; type = "-"; value = "188898"; }
  ];

  virtualisation.docker.enable = true;

  security.acme.certs."${kubernetesHostname}" = { };

  services.nginx.virtualHosts."${kubernetesHostname}" = {
    onlySSL = true;
    useACMEHost = kubernetesHostname;

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
    extraFlags = "--disable=traefik --tls-san=${kubernetesHostname}";
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
  #     in
  #     ''
  #       ${kubectl} create serviceaccount cluster-admin --namespace kube-system
  #       ${kubectl} create clusterrolebinding cluster-admin-manual --clusterrole=cluster-admin --serviceaccount=kube-system:cluster-admin
  #       ${kubectl} apply -f - <<EOF
  #         ---
  #         apiVersion: v1
  #         kind: Secret
  #         type: kubernetes.io/service-account-token
  #         metadata:
  #           name: cluster-admin-token
  #           namespace: kube-system
  #           annotations:
  #             kubernetes.io/service-account.name: cluster-admin
  #         EOF
  #     '';
  # };
}
