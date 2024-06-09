{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  rust-overlay,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./system.nix
    ./packages.nix
    ../../../modules/nix/nvidia.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
      rust-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
    };
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    # Make flake registry and nix path match flake inputs
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  networking.hostName = "nixos";
  security.polkit.enable = true;

  users.users = {
    sheke = {
      # Skip setting a root password by passing '--no-root-passwd' to nixos-install.
      initialPassword = "doubledeckerbus";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      ];
      extraGroups = ["networkmanager" "wheel" "docker"];
    };
  };

  programs.zsh.enable = true;
  users.users.sheke.shell = pkgs.zsh;
  environment.pathsToLink = ["/share/zsh"];

  programs.nix-ld = {
    enable = true;
  };
  programs.dconf.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = true;
    };
  };

  virtualisation.docker.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
