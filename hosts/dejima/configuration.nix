# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:
let
  teriyaki-ssh-key = lib.readFile ../teriyaki/id_ed25519.pub;
in
{
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Rome";

  networking.hostName = "dejima";
  networking.domain = "ar3s3ru.dev";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Disable documentation, we don't need it on servers anyway
  documentation.enable = false;

  # Users creation can only be controlled through this configuration.
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users.root.hashedPassword = "$6$IAwKbqRXgvJXNTPI$w8m6U48i5j9kCG9GoMSgeUC5XzIrxz9IA.8EmV91bZdlM.B82zI2.wdxR6SD.U8xBPlm3nIgtJGUvWChD.yYX/";
  users.users.root.openssh.authorizedKeys.keys = [ teriyaki-ssh-key ];

  environment.systemPackages = with pkgs; [
    wget
    lm_sensors
    patchelf
    ripgrep
    git
    git-crypt
    gopass
    gopass-jsonapi
    gnumake
    killall
    plantuml
    graphviz
    unzip
    pciutils
  ];

  # Enable virt-manager for some virtual machines.
  virtualisation.libvirtd.enable = true;

  # Better disk mounting.
  services.udisks2.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11";
}
