{ pkgs, config, ... }:

{
  # Tooling for vscode and stuff.
  home.packages = with pkgs; [
    gcc # For cgo
    gopls
    gotools
    go-outline
    gopkgs
    delve
    golangci-lint
  ];

  programs.go = {
    enable = true;
    package = pkgs.go_1_22;
  };
}
