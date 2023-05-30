{ config, pkgs, lib, ... }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  bazelbuild.vscode-bazel = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bazelbuild";
      name = "vscode-bazel";
      version = "0.7.0";
      sha256 = "/a34MMsHy7zmGrVAtjMWKmulwS+lip3J1YugkACMmxc=";
    };
  };

  bmewburn.vscode-intelephense-client = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bmewburn";
      name = "vscode-intelephense-client";
      version = "1.9.5";
      sha256 = "KqWSQ+p5KqRVULwjoWuNE+lIEYkaUVkeOwMpXUxccqw=";
    };
  };

  bufbuild.vscode-buf = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bufbuild";
      name = "vscode-buf";
      version = "0.5.1";
      sha256 = "73+VblPnfozEyqdqUJsUjGY6FKYS70keXIpEXS8EvxA=";
    };
  };

  dlasagno.rasi = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "dlasagno";
      name = "rasi";
      version = "1.0.0";
      sha256 = "s60alej3cNAbSJxsRlIRE2Qha6oAsmcOBbWoqp+w6fk=";
    };
  };

  jebbs.plantuml = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "jebbs";
      name = "plantuml";
      version = "2.17.2";
      sha256 = "e6eOhqGAASel4ywtj0j+kDInmcY5Ot5M4sOURwZ2tns=";
    };
  };

  fwcd.kotlin = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "fwcd";
      name = "kotlin";
      version = "0.2.26";
      sha256 = "djo1m0myIpEqz/jGyaUS2OROGnafY7YOI5T1sEneIK8=";
    };
  };

  kddejong.vscode-cfn-lint = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "kddejong";
      name = "vscode-cfn-lint";
      version = "0.24.3";
      sha256 = "2XpvjY1W0u9FCKhn2e2vPSsBk5pveqlmWCeqlUOlz3I=";
    };
  };

  editorconfig.edi = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "editorconfig";
      name = "edi";
      version = "0.16.4";
      sha256 = "";
    };
  };
in
{
  # NOTE: many of the required packages here are acutally installed already in nvim module.
  # If you can't find something here, look for it there.
  home.packages = with pkgs; [
    nixpkgs-fmt # Used by the nixos extension to format *.nix files.
    rnix-lsp # Used by nixos extension for autocompletion.
    python39Packages.autopep8 # Used by the python extension.
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;

    userSettings = {
      "editor.rulers" = [ 80 120 ];
      "editor.fontFamily" = "'Font Awesome','Terminus (TTF)','monospace', monospace,'Droid Sans Mono', 'Droid Sans Fallback'";
      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.suggestSelection" = "first";
      "files.insertFinalNewline" = true;
      "files.trimTrailingWhitespace" = true;
      "security.workspace.trust.untrustedFiles" = "open";

      # Golang configuration.
      "go.toolsManagement.autoUpdate" = false;
      "[go]" = { "editor.defaultFormatter" = "golang.go"; };
      "go.lintTool" = "golangci-lint";
      "go.alternateTools" = {
        "dlv" = "${pkgs.delve}/bin/dlv";
        "go" = "${config.programs.go.package}/bin/go";
        "gopls" = "${pkgs.gopls}/bin/gopls";
      };
      "gopls" = {
        "ui.semanticTokens" = true;
        "formatting.gofumpt" = true;
      };

      # Protobuf configuration.
      "[proto]" = { "editor.defaultFormatter" = "bufbuild.vscode-buf"; };
      "[proto3]" = { "editor.defaultFormatter" = "bufbuild.vscode-buf"; };

      # Markdown configuration.
      "markdown.extension.toc.omittedFromToc" = { };

      # Nix configuration.
      "nix.enableLanguageServer" = true;

      # Python configuration
      "python.formatting.autopep8Path" = "${pkgs.python39Packages.autopep8}/bin/autopep8";
      "python.languageServer" = "Pylance";

      # Configuration from ./machines/default.nix
      "plantuml.server" = "http://127.0.0.1:10808";
      "plantuml.render" = "PlantUMLServer";

      # These are for CloudFormation.
      "yaml.customTags" = [
        "!And"
        "!If"
        "!Not"
        "!Equals"
        "!Or"
        "!FindInMap sequence"
        "!Base64"
        "!Cidr"
        "!Ref"
        "!Sub"
        "!GetAtt"
        "!GetAZs"
        "!ImportValue"
        "!Select"
        "!Select sequence"
        "!Split"
        "!Join sequence"
      ];
      "yaml.format.enable" = true;
    };

    extensions = with pkgs.vscode-extensions; [
      bungcip.better-toml
      eamodio.gitlens
      golang.go
      hashicorp.terraform
      jnoortheen.nix-ide
      mechatroner.rainbow-csv
      matklad.rust-analyzer
      zxh404.vscode-proto3
      ms-python.python
      ms-python.vscode-pylance
      yzhang.markdown-all-in-one
      # ms-vsliveshare.vsliveshare
      # Local derivation modules
      bufbuild.vscode-buf
      bazelbuild.vscode-bazel
      bmewburn.vscode-intelephense-client
      dlasagno.rasi
      jebbs.plantuml
      fwcd.kotlin
      kddejong.vscode-cfn-lint
    ];
  };
}