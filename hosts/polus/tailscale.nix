{ ... }:

{
  networking.resolvconf.enable = true;
  # networking.resolvconf.extraConfig = ''
  #   name_servers="1.1.1.1"
  # '';

  services.tailscale.enable = true;
  services.tailscale.openFirewall = true;
  services.tailscale.useRoutingFeatures = "both";
  services.tailscale.extraUpFlags = [
    "--ssh"
    "--accept-dns"
    "--accept-routes"
    "--accept-risk=all"
    "--hostname=polus-picnic"
  ];
}
