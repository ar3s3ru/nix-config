let
  mkExt4Partition = (mountpoint: {
    type = "filesystem";
    format = "ext4";
    inherit mountpoint;
  });
in
{
  # Samsung 870 QVO 1TB SSD.
  # Main server disk, boot partition and LVM mountpoint.
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-Samsung_SSD_870_QVO_1TB_S5RRNF0TC03724D";
    content = {
      type = "gpt";
      partitions = {
        # Main boot partition for the server.
        boot = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        # Main LVM volume group.
        primary = {
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "dejima";
          };
        };
      };
    };
  };

  # Main server partition layout: home folders, Nix store, etc.
  disko.devices.lvm_vg.dejima = {
    type = "lvm_vg";

    lvs.root = {
      size = "5G";
      content = mkExt4Partition "/";
    };

    lvs.swap = {
      size = "16G";
      content.type = "swap";
    };

    lvs.nix = {
      size = "300G";
      content = mkExt4Partition "/nix";
    };

    lvs.var = {
      size = "350G";
      content = mkExt4Partition "/var";
    };

    lvs.home = {
      size = "+100%FREE";
      content = mkExt4Partition "/home";
    };
  };

  # Western Digital Black 1TB HDD.
  # Used for storing large objects that do not require fast access times.
  disko.devices.disk.sda = {
    type = "disk";
    device = "/dev/disk/by-id/ata-WDC_WD1002FAEX-00Z3A0_WD-WCATRA460090";
    content = {
      type = "gpt";
      partitions = {
        # Used to store any sort of media, like TV series, movies, etc.
        media = {
          size = "750G";
          content = mkExt4Partition "/media";
        };
        # Unpartitioned, we can use it to mount it on a VM.
        vm-slow = {
          size = "100%";
        };
      };
    };
  };
}
