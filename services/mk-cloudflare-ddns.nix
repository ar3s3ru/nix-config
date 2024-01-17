{ pkgs, ... }:

{ domain, proxied, token }:

{
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
}
