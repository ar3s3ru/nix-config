let
  port = 9345;
  hostname = "secrets.ar3s3ru.dev";
in
{
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_PORT = port;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_QR = true;
      MICROBIN_PUBLIC_PATH = "https://${hostname}";
      MICROBIN_EDITABLE = false;
      MICROBIN_PRIVATE = true;
    };
  };

  security.acme.certs."${hostname}" = { };

  services.nginx.virtualHosts."${hostname}" = {
    forceSSL = true;
    useACMEHost = hostname;

    locations."/" = {
      proxyPass = "http://localhost:${toString port}";
    };
  };
}
