{ pkgs, lib, ... }:
let
  nexusPassword = lib.strings.fileContents ./secrets/nexus-password;
in
{
  home.packages = with pkgs; [
    poetry
  ];

  home.file."poetry-config" = {
    executable = false;
    target = ".config/pypoetry/auth.toml";
    text = ''
      [http-basic.picnic]
      username = "dcianfrone"
      password = "${nexusPassword}"
    '';
  };
}