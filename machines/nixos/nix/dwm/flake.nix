{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
    in
      with pkgs; {
        devShell = mkShell {
          buildInputs = with pkgs; [clang-tools] ++ (with xorg; [libX11 libXinerama libXft]);
        };
      });
}
