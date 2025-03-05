{
  description = "devsheke's nixos configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

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
    nix-darwin,
    home-manager,
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays {inherit inputs;};

    darwinConfigurations."macos" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit self inputs outputs;};
      modules = [./machines/macos/nix];
    };

    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs outputs;};
      modules = [./machines/nixos/nix];
    };

    homeConfigurations."sheke@macos" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.aarch64-darwin;
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./machines/macos/home-manager];
    };

    homeConfigurations."sheke@nixos" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = {inherit inputs outputs;};
      modules = [./machines/nixos/home-manager];
    };
  };
}
