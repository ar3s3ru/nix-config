{ config, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "android_ip_webcam"
      "rtsp_to_webrtc"
      "onvif"
    ];
    config = {
      default_config = { };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}
