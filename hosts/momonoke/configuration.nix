{ lib, config, pkgs, ... }:

{
  time.timeZone = "Europe/Berlin";

  networking.hostName = "momonoke";
  networking.domain = "ar3s3ru.dev";
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp3s0.useDHCP = false;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Disable documentation, we don't need it on servers anyway
  documentation.enable = false;

  # Better disk mounting.
  services.udisks2.enable = true;

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
    unzip
    pciutils
  ];


  # Users creation can only be controlled through this configuration.
  users.mutableUsers = false;
  users.defaultUserShell = pkgs.fish;
  users.users.root.hashedPassword = "$6$IAwKbqRXgvJXNTPI$w8m6U48i5j9kCG9GoMSgeUC5XzIrxz9IA.8EmV91bZdlM.B82zI2.wdxR6SD.U8xBPlm3nIgtJGUvWChD.yYX/";
  users.users.ar3s3ru = {
    isNormalUser = true;
    hashedPassword = "$6$p00B1BzUBQwODVMp$gd6TsprpDnASh3RdWlBsmIBy1bVYUgiefk0oVemQuEe9QPQCOmS1wPpxBFPmZGqhNlIq/JlB0HlWvEf7A4kr0/";
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "docker"
      "libvirtd"
    ];
  };

  # Enable Sway, but configuration is in the Home Manager flake.
  programs.sway.enable = true;

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
  system.stateVersion = "22.05";
}
