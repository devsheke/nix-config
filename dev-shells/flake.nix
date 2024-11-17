{
  description = "devsheke's collection of development shells";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      nodePackages = pkgs.recurseIntoAttrs pkgs.nodePackages;
      ocamlPackages = pkgs.recurseIntoAttrs pkgs.ocamlPackages;
      pythonPackages = pkgs.recurseIntoAttrs pkgs.python312Packages;
    in
      with pkgs; {
        devShells.rust = mkShell {
          buildInputs = with pkgs; [pkg-config rust-analyzer];
          shellHook = ''
            export OPENSSL_DIR="${pkgs.openssl.dev}"
            export OPENSSL_NO_VENDOR=1
            export OPENSSL_LIB_DIR="${pkgs.lib.getLib pkgs.openssl}/lib"
            export PKG_CONFIG_PATH="${pkgs.openssl.dev}/lib/pkgconfig"
          '';
        };

        devShells.go = mkShell {
          buildInputs = with pkgs;
            [
              air
              golangci-lint
              golangci-lint-langserver
              golines
              gopls
              gotools
              sqlc
              templ
              tailwindcss-language-server
            ]
            ++ (with nodePackages; [
              vscode-css-languageserver-bin
              vscode-html-languageserver-bin
            ]);
        };

        devShells.js = mkShell {
          buildInputs = with pkgs;
            [
              nodejs_22
              pnpm
              prettierd
              tailwindcss-language-server
            ]
            ++ (with nodePackages; [
              eslint
              svelte-language-server
              typescript-language-server
              vscode-css-languageserver-bin
              vscode-html-languageserver-bin
              vscode-json-languageserver
            ]);
        };

        devShells.ocaml = mkShell {
          buildInputs = with pkgs;
            [dune_3 opam ocaml]
            ++ (with ocamlPackages; [
              core
              core_extended
              findlib
              merlin
              ocaml-lsp
              ocamlformat
              odoc
            ]);
        };

        devShells.python = mkShell {
          buildInputs = with pkgs; (with pythonPackages; [
            pyls-isort
            pylsp-rope
            python-lsp-black
            python-lsp-ruff
            python-lsp-server
          ]);
          shellHook = ''
            if [ -d ./.venv ]; then
              source ./.venv/bin/activate
            else
              echo "No python virtualenv found."
            fi
          '';
        };
      });
}
