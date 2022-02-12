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
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    config.pipewire = {
      "context.properties" = {
        #"link.max-buffers" = 64;
        "link.max-buffers" = 16; # version < 3 clients can't handle more than this
        "log.level" = 2; # https://docs.pipewire.org/page_daemon.html
        #"default.clock.rate" = 48000;
        #"default.clock.quantum" = 1024;
        #"default.clock.min-quantum" = 32;
        #"default.clock.max-quantum" = 8192;
      };

      # "context.objects" = [
      #   {
      #     factory = "adapter";
      #     args = {
      #       "factory.name" = "support.null-audio-sink";
      #       "node.name" = "Microphone-Proxy";
      #       "node.description" = "Microphone";
      #       "media.class" = "Audio/Source/Virtual";
      #       "audio.position" = "MONO";
      #     };
      #   }
      # ];
    };

    media-session.config.alsa-monitor.rules = [
      {
        matches = [{ "node.name" = "~alsa_input.*"; }];
        actions = {
          "update-props" = {
            "api.alsa.use-acp" = false;
            "api.alsa.use-ucm" = true;
          };
        };
      }
    ];

    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.auto-connect" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
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