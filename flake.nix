{
  description = "devsheke's nixos configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-darwin,
    home-manager,
    rust-overlay,
    spicetify-nix,
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};

    darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit self inputs outputs rust-overlay;};
      modules = [./hosts/macos/nix/configuration.nix];
    };
    darwinPackages = self.darwinConfigurations."macos".pkgs;

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs rust-overlay;};
        modules = [./hosts/nixos/nix/configuration.nix];
      };
    };

    homeConfigurations = {
      "sheke@macos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-darwin;
        extraSpecialArgs = {inherit inputs outputs spicetify-nix;};
        modules = [
          ./hosts/macos/home-manager/home.nix
          ./modules/spicetify/spicetify.nix
        ];
      };

      "sheke@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = {inherit inputs outputs home-manager spicetify-nix;};
        modules = [
          ./hosts/nixos/home-manager/home.nix
          ./modules/spicetify/spicetify.nix
        ];
      };
    };
  };
}
