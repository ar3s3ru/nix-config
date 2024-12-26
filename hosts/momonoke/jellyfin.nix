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
  services.nginx.virtualHosts."jellyfin2.ar3s3ru.dev" = {
    forceSSL = true;
    enableACME = true;

    locations."/" = {
      proxyPass = "http://localhost:8096";
      proxyWebsockets = true;

      extraConfig = ''
        # Disable buffering when the nginx proxy gets very resource heavy upon streaming
        proxy_buffering off;
      '';
    };

    extraConfig = ''
      # NOTE: from https://jellyfin.org/docs/general/networking/nginx/#nginx-from-a-subdomain-jellyfinexampleorg
      #
      # The default `client_max_body_size` is 1M, this might not be enough for some posters, etc.
      client_max_body_size 20M;

      # Security / XSS Mitigation Headers
      # NOTE: X-Frame-Options may cause issues with the webOS app
      # add_header X-Frame-Options "SAMEORIGIN";
      add_header X-XSS-Protection "0"; # Do NOT enable. This is obsolete/dangerous
      add_header X-Content-Type-Options "nosniff";
    '';
  };


  # Enable vaapi on OS-level
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-vaapi-driver
    vaapiVdpau
    intel-compute-runtime
    # vpl-gpu-rt # QSV on 11th gen or newer
    intel-media-sdk # QSV up to 11th gen
  ];
}
