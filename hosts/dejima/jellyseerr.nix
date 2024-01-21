{ pkgs, config, ... }:

{
  services.jellyseerr.enable = true;
  services.jellyseerr.openFirewall = false;

  security.acme.certs."ar3s3ru.dev".extraDomainNames = [
    "jellyseerr.ar3s3ru.dev"
  ];

  # Expose the Plex server through NGINX, this avoids the need for opening ports
  # on the router.
  services.nginx.virtualHosts."jellyseerr.ar3s3ru.dev" = {
    forceSSL = true;
    useACMEHost = "ar3s3ru.dev";

    locations."/" = {
      proxyPass = "http://localhost:${toString config.services.jellyseerr.port}";
      proxyWebsockets = true;
    };
  };
}
