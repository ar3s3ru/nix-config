{ config, pkgs, ... }:

{
  # Mostly following: https://adityatelange.in/blog/android-phone-webcam-linux/
  environment.systemPackages = with pkgs; [
    scrcpy
    ffmpeg
    v4l-utils
  ];

  programs.adb.enable = true;

  # Source: https://wiki.nixos.org/wiki/Droidcam
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];

  boot.extraModprobeConfig = ''
    options v4l2loopback card_label="Android Virtual Webcam" exclusive_caps=1
  '';

  security.polkit.enable = true;
}
