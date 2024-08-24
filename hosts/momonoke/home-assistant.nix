{ config, pkgs, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  services.home-assistant = {
    enable = true;
    extraPackages = ps: with pkgs.python3Packages; [
      idasen_ha
    ];
    extraComponents = [
      "camera"
      "android_ip_webcam"
      "rtsp_to_webrtc"
      "onvif"
      "ibeacon"
      "switchbot"
      "govee_ble"
      "google_translate"
      "xiaomi_ble"
      "idasen_desk"
    ];
    config = {
      default_config = { };
      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };
    };
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
