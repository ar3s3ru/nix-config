{ ... }:

{
  # Enable Podman for containers with Docker compatibility.
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerCompat = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.autoPrune.enable = true;
}
