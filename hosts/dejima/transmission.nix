{ ... }:

{
  services.transmission.enable = true;
  services.transmission.openFirewall = true;
  services.transmission.openRPCPort = false; # We use the WebUI for now.
  services.transmission.openPeerPorts = true;

  services.transmission.settings = {
    rpc-authentication-required = false;
    rpc-whitelist-enabled = false;
    rpc-host-whitelist-enabled = false;
  };

  security.acme.certs."transmission.ar3s3ru.dev" = { };

  # Expose the Transmission WebUI through NGINX,
  # this avoids the need for opening ports on the router.
  services.nginx.virtualHosts."transmission.ar3s3ru.dev" = {
    forceSSL = true;
    useACMEHost = "transmission.ar3s3ru.dev";

    locations."/" = {
      proxyPass = "http://localhost:9091";
      proxyWebsockets = true;
    };
  };
}
