{ config, pkgs, libs, ... }:

{
  home.packages = with pkgs; [
    fzf
    bat
    duf
    eza
    prettyping
    htop
  ];

  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "22dd68487b2e53ee6f2bddef69cfd9c0c643bb95";
          sha256 = "0973wy17h4ic2g5pk6f2mqzzsrn6pka9n8m2nn9fww3b2xnib9ms";
        };
      }
      {
        name = "fish-color-scheme-switcher";
        src = pkgs.fetchFromGitHub {
          owner = "h-matsuo";
          repo = "fish-color-scheme-switcher";
          rev = "64f8e346049f0290e174f560d55af3c53f633fdd";
          sha256 = "0x2d5arzxgg2ibqmsnxk5kpnkyg3vpbyy54f92b6dm5lyf0rb8sl";
        };
      }
    ];

    shellAliases = {
      cat = "bat";
      du = "duf";
      ls = "eza";
      top = "htop";
      ping = "prettyping --nolegend";
    };

    shellAbbrs = {
      gp = "git push";
      gpf = "git push --force-with-lease";
      kgp = "kubectl get pods";
    };

    functions = {
      gbpurge = {
        description = "Removes branches that are either stale or deleted from upstream.";
        body = "git fetch -p && git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D";
      };

      gca = {
        description = "Use gca for adding new changes and amending them in the last Git commit without editing";
        body = "git add . && git commit --amend --no-edit";
      };
    };
  };
}
