{
  description = "devsheke's nixos configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/8809585e6937d0b07fc066792c8c9abf9c3fe5c4";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    flake-utils,
    nix-darwin,
    home-manager,
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      inherit (self) outputs;
      pkgs = import nixpkgs {inherit system;};
    in {
      overlays = import ./overlays {inherit inputs;};

      devShell = pkgs.mkShell {
        buildInputs = with pkgs; [clang-tools] ++ (with xorg; [libX11 libXinerama libXft]);
      };

      darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit self inputs outputs;};
        modules = [./machines/macos/nix];
      };

      nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [./machines/nixos/nix];
      };

      homeConfigurations."sheke@macos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./machines/macos/home-manager];
      };

      homeConfigurations."sheke@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [./machines/nixos/home-manager];
      };
    });
}
