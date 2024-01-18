{ ... }:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Track home-manager under the configuration.
  programs.home-manager.enable = true;
}
