{
  services.spice-vdagentd.enable = true;
  services.spice-webdavd.enable = true;


  # share /mnt/utm 9p trans=virtio,version=9p2000.L,rw,_netdev,nofail,auto 0 0
  fileSystems."/mnt/utm" = {
    device = "share";
    fsType = "9p";
    options = [ "trans=virtio" "version=9p2000.L" "rw" "_netdev" "nofail" "auto 0 0" ];
  };
}
