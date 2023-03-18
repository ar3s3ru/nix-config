{ pkgs, config, lib, ... }:

{
  imports = [
    ../modules/shared.nix
    ../modules/homebrew.nix
  ];

  system.stateVersion = 4;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Enable GnuPG Agent.
  # Please note, the actual agent config (e.g. pinentry)
  # is part of modules/gpg-darwin.nix.
  programs.gnupg.agent.enable = true;

  # NOTE: this is not working
  # security.pam.enableSudoTouchIdAuth = true;

  # QoL: Mac key mapping is confusing AF, make it more like Linux.
  # system.keyboard.enableKeyMapping = true;
  # system.keyboard.swapLeftCommandAndLeftAlt = true;

  # Enable fish shell globally, but configuration is in the Home Manager flake.
  programs.fish.enable = true;
  environment.shells = [ pkgs.fish ];

  users.users.ar3s3ru = {
    home = "/Users/ar3s3ru";
    shell = "${pkgs.fish}/bin/fish";
  };

  users.users.root = {
    home = "/var/root";
    shell = "${pkgs.fish}/bin/fish";
  };

  environment.variables = {
    EDITOR = "nvim";
  };

  # TODO enable
  # system.defaults.NSGlobalDomain = {
  #   InitialKeyRepeat = 33; # unit is 15ms, so 500ms
  #   KeyRepeat = 2; # unit is 15ms, so 30ms
  #   NSDocumentSaveNewDocumentsToCloud = false;
  # };

  fonts = {
    fontDir.enable = true;

    fonts = with pkgs; [
      nerdfonts
      terminus_font
      terminus_font_ttf
    ];
  };
}
