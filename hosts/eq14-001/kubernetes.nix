{ pkgs, lib, ... }:
let
  clusterToken = lib.readFile ../secrets/nl-homelab-k3s-token;
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

  virtualisation.docker.enable = true;

  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # Allow ingress traffic to Traefik on Kubernetes.
  networking.firewall.allowedTCPPorts = [ 80 443 2379 2380 6443 ];
  networking.firewall.allowedUDPPorts = [ 8472 ];

  # Kubernetes through K3S.
  services.k3s = {
    enable = true;
    role = "agent";
    token = clusterToken;
    serverAddr = "https://192.168.2.109:6443";
  };
}
