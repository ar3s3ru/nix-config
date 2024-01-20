{ config, pkgs, lib, ... }:
let
  inherit (pkgs.vscode-utils) buildVscodeMarketplaceExtension;

  bazelbuild.vscode-bazel = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "bazelbuild";
      name = "vscode-bazel";
      version = "0.8.1";
      sha256 = "VbFbFi77hTBJtXXI+jdp5l8wMIRx0UrXt5tXHs3xaDE=";
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
      version = "0.5.3";
      sha256 = "ZfwTj6S54H0ympdjc4/3xBwlvR7zg4vJ98gyVwL8ZRw=";
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
      version = "2.17.5";
      sha256 = "C/kf+rYGTIdExxivNKHWeOzNsPAOWz2jn4sc52+sClA=";
    };
  };

  fwcd.kotlin = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "fwcd";
      name = "kotlin";
      version = "0.2.34";
      sha256 = "03F6cHIA9Tx8IHbVswA8B58tB8aGd2iQi1i5+1e1p4k=";
    };
  };

  editorconfig.editorconfig = buildVscodeMarketplaceExtension {
    mktplcRef = {
      publisher = "editorconfig";
      name = "editorconfig";
      version = "0.16.4";
      sha256 = "sha256-j+P2oprpH0rzqI0VKt0JbZG19EDE7e7+kAb3MGGCRDk=";
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

  programs.vscode.enable = true;
  programs.vscode.mutableExtensionsDir = true;

  programs.vscode.extensions = with pkgs.vscode-extensions; [
    tamasfe.even-better-toml
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
    esbenp.prettier-vscode
    bradlc.vscode-tailwindcss
    dbaeumer.vscode-eslint
    jnoortheen.nix-ide
    mkhl.direnv
    # ms-vsliveshare.vsliveshare
    # Local derivation modules
    editorconfig.editorconfig
    bufbuild.vscode-buf
    bazelbuild.vscode-bazel
    bmewburn.vscode-intelephense-client
    dlasagno.rasi
    jebbs.plantuml
    fwcd.kotlin
  ];

  programs.vscode.userSettings = {
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

    "[json|jsonc]" = {
      "editor.defaultFormatter" = "vscode.json-language-features";
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

    # Configuration from ./hosts/default.nix
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
}
