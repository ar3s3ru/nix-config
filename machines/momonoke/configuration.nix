{ lib, config, pkgs, ... }:
let
  makeCloudflareDdns = { domain, proxied, token }: {
    enable = true;
    description = "Run Dynamic DNS to update ${domain} public IP address";

    wantedBy = [ "multi-user.target" ];

    # This service requires network connection, or it won't work.
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment = {
      CF_API_TOKEN = token;
      DOMAINS = domain;
      PROXIED = proxied;
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.cloudflare-ddns}/bin/ddns";
      Restart = "always";
      RestartSec = "30s";
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
    ../modules/shared.nix
    ../modules/linux.nix
    ../modules/physical.nix
  ];

  programs.adb.enable = true;
  users.users.ar3s3ru.extraGroups = [ "adbusers" ];

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking = {
    hostName = "momonoke";

    useDHCP = false;
    interfaces.enp0s31f6.useDHCP = true;
    interfaces.wlp3s0.useDHCP = true;
  };

  systemd.services."ddns-prod.flugg.app" = makeCloudflareDdns {
    domain = "prod.flugg.app";
    proxied = "true";
    token = lib.readFile ./secrets/cloudflare-token;
  };

  systemd.services."ddns-momonoke.ar3s3ru.dev" = makeCloudflareDdns {
    domain = "momonoke.ar3s3ru.dev";
    proxied = "false";
    token = lib.readFile ./secrets/cloudflare-token-ar3s3ru.dev;
  };
}
