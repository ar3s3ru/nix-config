{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [
    gh
  ];

  programs.git = {
    enable = true;
    userName = "Danilo Cianfrone";
    userEmail = "danilocianfr@gmail.com";

    extraConfig = {
      core.editor = "nvim";
      init.defaultBranch = "main";

      commit.gpgSign = true;
      tag.gpgSign = true;

      push.autoSetupRemote = true;

      credential."https://github.com".helper = "${pkgs.gh}/bin/gh auth git-credential";
    };
  };

  xdg.configFile."gh/config.yml".text = /* yml */ ''
    version: 1 # https://github.com/nix-community/home-manager/issues/4744
    git_protocol: https
    editor:
    prompt: enabled
    pager:
    aliases:
        co: pr checkout
    http_unix_socket:
    browser:
  '';
}
