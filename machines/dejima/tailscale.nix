{ pkgs, lib, config, ... }:

{
  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  services.tailscale.useRoutingFeatures = "server";
  services.tailscale.authKeyFile = ./secrets/headscale-preauth-key;
  services.tailscale.extraUpFlags = [
    "--accept-dns"
    "--advertise-exit-node"
    "--hostname=dejima"
    "--login-server=https://vpn.flugg.app"
  ];
}
