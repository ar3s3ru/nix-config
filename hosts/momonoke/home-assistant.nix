{ config, ... }:

{
  # Home Assistant prefers dbus-broker for the DBus protocol and using Bluetooth.
  services.dbus.implementation = "broker";

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  virtualisation.oci-containers.containers.home-assistant = {
    image = "ghcr.io/home-assistant/home-assistant:2024.8.2";
    environment = {
      TZ = "Europe/Berlin";
    };
    extraOptions = [
      "--privileged"
    ];
    ports = [
      "0.0.0.0:8123:8123"
    ];
    volumes = [
      "/var/lib/home-assistant:/config"
      "/dev:/dev"
      "/run/udev:/run/udev"
      "/run/dbus:/run/dbus:ro"
    ];
  };

  security.acme.certs."berlin.home.ar3s3ru.dev" = { };

  services.nginx.virtualHosts."berlin.home.ar3s3ru.dev" = {
    forceSSL = true;
    useACMEHost = "berlin.home.ar3s3ru.dev";

    locations."/" = {
      proxyPass = "http://localhost:8123";
      proxyWebsockets = true;
    };

    extraConfig = ''
      # Disable buffering when the nginx proxy gets very resource heavy upon streaming
      proxy_buffering off;
    '';
  };
}
