{ lib
, buildGo123Module
, fetchFromGitHub
}:

let
  name = "cloudflare-ddns";
  version = "1.11.0";
in

buildGo123Module {
  pname = name;
  inherit version;

  CGO_ENABLED = 1;

  src = fetchFromGitHub {
    owner = "favonia";
    repo = name;
    rev = "v${version}";
    hash = "sha256-YFSaBe8fgwOVdP7vVK2V7ZEanxmyuVAv5xOI1iwNmQQ=";
  };

  doCheck = false;

  vendorHash = "sha256-Y3wsHptB4BJcZTZfrkqCwQemIV9hi5THlynZMpB/+a0=";

  ldflags = [
    "-s"
    "-w"
    "-X=github.com/favonia/cloudflare-ddns/cmd/ddns.Version=v${version}"
  ];

  meta = with lib; {
    description = "A small, feature-rich, and robust Cloudflare DDNS updater";
    license = licenses.asl20;
    homepage = "https://github.com/favonia/cloudflare-ddns";
    platforms = platforms.linux;
  };
}
