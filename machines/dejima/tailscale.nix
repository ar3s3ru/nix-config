{ pkgs, lib, config, ... }:

{
  # NOTE: though we advertise as exit-node, the route must be enabled
  # on the Headscale server, using `headscale routes enable -r ID`
  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  services.tailscale.useRoutingFeatures = "both";
  services.tailscale.authKeyFile = ./secrets/headscale-preauth-key;
  services.tailscale.extraUpFlags = [
    "--ssh"
    "--accept-dns"
    "--accept-risk=all"
    "--advertise-exit-node"
    "--advertise-routes=192.168.178.0/24" # To access the local router.
    "--hostname=dejima"
    "--login-server=https://vpn.flugg.app"
  ];
}
