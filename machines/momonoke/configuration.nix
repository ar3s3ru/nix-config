{ lib, config, pkgs, ... }:

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

  systemd.services."cloudflare-ddns" = {
    enable = true;
    description = "Run Dynamic DNS to update api.flugg.app public IP address";

    # This service requires network connection, or it won't work.
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];

    environment = {
      CF_API_TOKEN = lib.readFile ./secrets/cloudflare-token;
      DOMAINS = "api.flugg.app";
      PROXIED = "false";
    };

    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.cloudflare-ddns}/bin/ddns";
      Restart = "always";
      RestartSec = "30s";
    };
  };
}
