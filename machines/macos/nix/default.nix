{
  self,
  outputs,
  pkgs,
  ...
}: let
  packages = import ../../../modules/nix/packages.nix pkgs;
in {
  imports = [
    ./brew.nix
    ./services/skhd.nix
    ./services/yabai.nix
  ];

  nix = {
    enable = true;
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "aarch64-darwin";
    overlays = [
      outputs.overlays.stable-packages
    ];
  };

  programs.zsh.enable = true;
  environment.systemPackages = with pkgs;
    packages.common
    ++ packages.devTools
    ++ (with darwin; [
      apple_sdk.frameworks.Foundation
      apple_sdk.frameworks.Security
    ]);

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    nerd-fonts.overpass
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
