{ pkgs, ... }:

{
  # Main setup from https://nixos.wiki/wiki/Jellyfin

  services.jellyfin.enable = true;

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  # Expose the Plex server through NGINX, this avoids the need for opening ports
  # on the router.
  services.nginx.virtualHosts."jellyfin.ar3s3ru.dev" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://localhost:8096";
      proxyWebsockets = true;
    };

    extraConfig = ''
      # Some players don't reopen a socket and playback stops totally instead of resuming after an extended pause
      send_timeout 100m;

      # Buffering off send to the client as soon as the data is received from Jellyfin.
      proxy_redirect off;
      proxy_buffering off;
    '';
  };
}
