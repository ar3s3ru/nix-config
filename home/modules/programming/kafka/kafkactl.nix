{ stdenv, lib, fetchzip }:
let
  version = "2.3.0";
in
stdenv.mkDerivation rec {
  pname = "kafkactl";
  inherit version;

  src = fetchzip {
    url = "https://github.com/deviceinsight/kafkactl/releases/download/v${version}/kafkactl_${version}_linux_amd64.tar.gz";
    sha256 = "sha256-zKTH6qY/rHP0lrMLL7hOWN6aJwZOKdmEghk3y85RUHc=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp kafkactl $out/bin
  '';
}
