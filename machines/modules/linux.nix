{ config, pkgs, lib, ... }:

{
  boot = {
    # Use the latest Linux kernel version cause YOLO!
    kernelPackages = pkgs.linuxPackages_latest;

    # Use the systemd-boot EFI boot loader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;

    # Limit the number of available generations on the bootloader
    # to the latest 3.
    loader.systemd-boot.configurationLimit = 3;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  networking = {
    networkmanager.enable = true;
    networkmanager.insertNameservers = [
      "1.1.1.1"
      "8.8.8.8"
    ];
  };

  # Enable Docker for containers.
  virtualisation.docker.enable = true;

  # Neovim is the best text editor period bye.
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # Enable fish shell globally, but configuration is in the Home Manager flake.
  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  # Users creation can only be controlled through this configuration.
  users.mutableUsers = false;
  users.users = {
    root = {
      hashedPassword = "$6$IAwKbqRXgvJXNTPI$w8m6U48i5j9kCG9GoMSgeUC5XzIrxz9IA.8EmV91bZdlM.B82zI2.wdxR6SD.U8xBPlm3nIgtJGUvWChD.yYX/";
    };

    ar3s3ru = {
      isNormalUser = true;
      hashedPassword = "$6$p00B1BzUBQwODVMp$gd6TsprpDnASh3RdWlBsmIBy1bVYUgiefk0oVemQuEe9QPQCOmS1wPpxBFPmZGqhNlIq/JlB0HlWvEf7A4kr0/";
      extraGroups = [
        "wheel"
        "networkmanager"
        "video"
        "audio"
        "docker"
        "plantuml"
        "libvirtd"
      ];
    };
  };

  # Enable the Display Manager, we need X.org for that :(
  services.xserver = {
    enable = true;
    layout = "us";

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = false;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

  # Enable Sway, but configuration is in the Home Manager flake.
  programs.sway.enable = true;

  # Handle the lid and sleep as the Macbook does.
  services.logind = {
    lidSwitch = "suspend-then-hibernate";
    lidSwitchDocked = "ignore";
    lidSwitchExternalPower = "ignore";
  };

  # Enable xdg-desktop-portal support for screensharing in Wayland,
  # but additional configuration can be found in users/ar3s3ru/sway/xdg-desktop-portal.nix
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    gtkUsePortal = true;
  };

  # Add support for gnome-keyring.
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Add OpenSSH server support to generate host keys.
  services.openssh = {
    enable = true;
  };

  # Enable PlantUML server for rendering.
  services.plantuml-server = {
    enable = true;
    listenPort = 10808;
  };

  # Better disk mounting.
  services.udisks2 = {
    enable = true;
  };
}
