let
  ext4Partition = {
    type = "filesystem";
    format = "ext4";
  };

  mkExt4Partition = (mountpoint: ext4Partition // {
    inherit mountpoint;
  });
in
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/nvme-KBG6AZNV512G_LA_KIOXIA_4ENPSK41Z12L";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        primary = {
          size = "100%";
          content = {
            type = "lvm_pv";
            vg = "nixos";
          };
        };
      };
    };
  };

  # Main server partition layout: home folders, Nix store, etc.
  disko.devices.lvm_vg.nixos = {
    type = "lvm_vg";

    lvs.root = {
      size = "5G";
      content = mkExt4Partition "/";
    };

    lvs.swap = {
      size = "30G";
      content.type = "swap";
    };

    lvs.nix = {
      size = "100G";
      content = mkExt4Partition "/nix";
    };

    lvs.var = {
      size = "200G";
      content = mkExt4Partition "/var";
    };

    lvs.home = {
      size = "+100%FREE";
      content = mkExt4Partition "/home";
    };
  };
}
