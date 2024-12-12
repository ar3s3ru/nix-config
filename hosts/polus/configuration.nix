{ lib, pkgs, ... }:

{
  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "polus";
  networking.networkmanager.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

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
    networkmanagerapplet
    powertop
    usbutils # For lsusb.
    sof-firmware # Needed to get the headphones audio working.
    python3
    nodejs
    awscli2
  ];

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
  programs.regreet.enable = true;

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
