{ pkgs, ... }:

{
  # Enable fish shell globally, but configuration is in the Home Manager flake.
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];
  users.defaultUserShell = pkgs.fish;
}
