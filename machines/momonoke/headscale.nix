{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    headscale-alpha
  ];

  # TODO: not sure this is the right thing to do...
  # I'm trying with setting up the node manually on the network, but
  # I'm not sure that's the correct thing to do.
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    openFirewall = true;
  };

  services.headscale = {
    enable = true;
    package = pkgs.headscale-alpha;
    port = 10080;

    settings = {
      server_url = "https://vpn.flugg.app";

      dns_config = {
        base_domain = "flugg.app";
        domains = [ "flugg.app" ];

        nameservers = [
          "9.9.9.9"
          "1.1.1.1"
          "8.8.8.8"
        ];

        override_local_dns = true;
      };

      logtail.enabled = false;
    };
  };
}
