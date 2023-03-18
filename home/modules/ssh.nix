{ config, pkgs, ssh, ... }:
let
  private-key-filename = builtins.baseNameOf ssh.private-key;
  public-key-filename = builtins.baseNameOf ssh.public-key;
in
{
  programs.ssh = {
    enable = true;
  };

  home.file.".ssh/${private-key-filename}".source = ssh.private-key;
  home.file.".ssh/${public-key-filename}".source = ssh.public-key;
}
