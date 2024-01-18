{ config, lib, pkgs, ... }:

{
  # Use the latest Linux kernel version cause YOLO!
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Limit the number of available generations on the bootloader
  # to the latest 3.
  boot.loader.systemd-boot.configurationLimit = 3;
}
