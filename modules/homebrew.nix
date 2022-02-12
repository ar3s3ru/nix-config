{ config, pkgs, lib, ... }:

{
  # Make Homebrew binaries runnable.
  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  # Make yabai run "sudo" without password.
  # Necessary for script injection.
  environment.etc."sudoers.d/yabai" = {
    enable = true;
    text = ''
      ar3s3ru ALL = (root) NOPASSWD: /opt/homebrew/bin/yabai --load-sa
    '';
  };

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap"; # "zap" removes manually installed brews and casks
    };

    brews = [
      "yabai"
      "skhd"
      "pnpm"
      "nvm"
      "node"
      "yarn"
    ];

    taps = [
      # default
      "homebrew/bundle"
      "homebrew/cask"
      "homebrew/cask-drivers"
      "homebrew/core"
      "homebrew/services"
      # custom
      "cmacrae/formulae" # spacebar
      "koekeishiya/formulae" # yabai
    ];
  };
}
