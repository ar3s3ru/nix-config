# Shared configuration parameters that applies
# for physical machines.

{ config, pkgs, lib, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = with pkgs; [
      acpi
      powertop
      openvpn
      lm_sensors
      virt-manager
      patchelf
      # Packages needed for mounting iOS devices.
      libimobiledevice
      ifuse
    ];
  };

  # Power management
  services.acpid.enable = true;
  services.power-profiles-daemon.enable = false;
  powerManagement.powertop.enable = true;

  # Bluetooth configuration.
  services.blueman.enable = true;
  hardware.bluetooth.enable = true;

  # Pipewire with bluetooth support.
  # Copied from https://nixos.wiki/wiki/PipeWire
  #
  # TODO: move the PipeWire configuration to files.
  # Context: https://github.com/NixOS/nixpkgs/commit/1fab86929f7df5cdd60bcf65b4c78f4058777a03
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    wireplumber.enable = true;

    alsa = {
      enable = true;
      support32Bit = true;
    };
  };

  # Enable virt-manager for some virtual machines.
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  # Enable printer discovery through Avahi
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Enable CUPS for printing documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ ];
  };

  # Enable support for mounting iOS devices.
  services.usbmuxd.enable = true;
}

