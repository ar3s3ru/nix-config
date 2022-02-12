{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
    ../linux.nix
    ../physical.nix
  ];

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/4e9aca04-d949-424e-b64a-8ce47fb52cb0";

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
