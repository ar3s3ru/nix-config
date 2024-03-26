{ ... }:

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
      "podman"
    ];

    casks = [
      "dbeaver-community"
      "podman-desktop"
    ];

    taps = [
      "cmacrae/formulae" # spacebar
      "koekeishiya/formulae" # yabai
    ];
  };
}
