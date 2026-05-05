{
  description = "devsheke's nix (and nix-darwin) configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    elephant.url = "github:abenz1267/elephant";

    walker = {
      url = "github:abenz1267/walker";
      inputs.elephant.follows = "elephant";
    };
  };

  outputs = {
    self,
    darwin,
    home-manager,
    nixpkgs,
    ...
  } @ args: let
    vars = {
      user = "sheke";
    };
  in {
    darwinConfigurations."macos" = darwin.lib.darwinSystem {
      specialArgs = {inherit self args nixpkgs vars;};
      modules = [
        ./hosts/macos
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };

      nixosConfigurations."sanguinius" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Defines the architecture as standard x86_64
      specialArgs = {inherit self args nixpkgs vars;};
      modules = [
        ./hosts/sanguinius
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
      ];
    };
  };
}
