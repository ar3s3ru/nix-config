{ pkgs, config, ... }:
let
  headscaleNetworkName = "intranet";
  headscale = "${config.services.headscale.package}/bin/headscale";
in
{
  environment.systemPackages = with pkgs; [
    headscale-alpha
  ];

  services.headscale = {
    enable = true;
    package = pkgs.headscale-alpha;
    port = 10080;

    settings = {
      server_url = "https://vpn.flugg.app";

      # NOTE: these are the default ips.
      ip_prefixes = [
        "fd7a:115c:a1e0::/48"
        "100.64.0.0/10"
      ];

      dns_config = {
        base_domain = "flugg.app";
        domains = [ "flugg.app" ];

        nameservers = [
          "9.9.9.9"
          "1.1.1.1"
          "8.8.8.8"
        ];

        override_local_dns = false;
      };

      logtail.enabled = false;
    };
  };

  systemd.services."headscale-create-${headscaleNetworkName}-user" = {
    enable = true;
    description = "Creates the '${headscaleNetworkName}' user on Headscale server";

    wants = [ "headscale.service" ];
    after = [ "headscale.service" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = config.services.headscale.user;
      Group = config.services.headscale.group;
    };

    script = ''
      # For some reason, headscale fails on this command.
      # We're skipping errors to make the script work.
      set +e

      already_exists="$(${headscale} users list | grep ${headscaleNetworkName})"
      if [ -z "$already_exists" ]; then
        ${headscale} users create ${headscaleNetworkName}
      fi
    '';
  };

  systemd.services."headscale-generate-preauth-for-tailscale" = {
    enable = true;
    description = "Creates a preauth token for Tailscale client to automatically configure this node";

    wants = [
      "headscale.service"
      "tailscale.service"
      "tailscaled-autoconnect.service"
    ];

    after = [
      "headscale.service"
      "tailscale.service"
      "headscale-create-${headscaleNetworkName}-user.service"
    ];

    before = [ "tailscaled-autoconnect.service" ];

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
    };

    script = ''
      ${headscale} preauthkeys create -u ${headscaleNetworkName} > /etc/headscale/${headscaleNetworkName}-preauthkey
    '';
  };

  services.tailscale = {
    enable = true;
    useRoutingFeatures = "server";
    openFirewall = true;

    # TODO: maybe also advertise certain tags?
    authKeyFile = "/etc/headscale/${headscaleNetworkName}-preauthkey";
    extraUpFlags = [
      "--accept-dns"
      "--advertise-exit-node"
      "--hostname=prod"
      "--login-server=http://localhost:${toString config.services.headscale.port}"
    ];
  };
}
