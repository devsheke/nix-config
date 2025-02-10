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
    # ./services/yabai.nix
  ];

  nix = {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = "x86_64-darwin";
    overlays = [
      outputs.overlays.stable-packages
    ];
  };

  programs.zsh.enable = true;
  environment.systemPackages =
    packages.common
    ++ packages.devTools
    ++ (with pkgs; (with darwin; [
      apple_sdk.frameworks.Foundation
      apple_sdk.frameworks.Security
    ]));

  fonts.packages = with pkgs; [
    nerd-fonts.geist-mono
    nerd-fonts.overpass
  ];

  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
  ids.uids.nixbld = 350;
  system.configurationRevision = self.rev or self.dirtyRev or null;
}
