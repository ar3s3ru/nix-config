{ lib, config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nginx-ingress.nix
    ./kubernetes.nix
    ./headscale.nix
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
}
