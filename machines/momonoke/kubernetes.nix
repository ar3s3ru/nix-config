{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    k3s
    openssl # Used to generate user account CSRs.
    helm
  ];

  virtualisation.containerd.enable = true;

  services.k3s = {
    enable = true;
    role = "server";

    extraFlags = ''
      --disable traefik
      --tls-san k8s.flugg.app
    '';
  };
}
