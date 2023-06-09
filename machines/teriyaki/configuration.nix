# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../modules/shared.nix
    ../modules/linux.nix
    ../modules/physical.nix
  ];

  boot.loader.efi.canTouchEfiVariables = false;
  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/23e4dd23-9e8c-4e04-b8ac-13277bb9eb13";

  hardware.asahi.addEdgeKernelConfig = true;
  hardware.asahi.pkgs = lib.mkDefault pkgs;
  hardware.asahi.useExperimentalGPUDriver = true;
  hardware.asahi.extractPeripheralFirmware = false;

  networking.hostName = "teriyaki";
  networking.useDHCP = lib.mkForce true;
}
