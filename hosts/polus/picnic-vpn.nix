{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    openconnect
    networkmanager-openconnect
  ];

  networking.openconnect.interfaces."openconnect0" = {
    gateway = "vpn.picnic.systems";
    protocol = "anyconnect";
    user = "danilo.cianfrone@teampicnic.com";
    autoStart = false;
  };
}
