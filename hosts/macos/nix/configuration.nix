{
  self,
  outputs,
  pkgs,
  rust-overlay,
  ...
}: let
  packages = import ../../../modules/nix/packages.nix pkgs;
in {
  imports = [
    ./brew.nix
    ./services/yabai.nix
    ./services/skhd.nix
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

  fonts = {
    fontDir.enable = true;
    fonts = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
    ];
  };

  services.nix-daemon.enable = true;

  nix.settings.experimental-features = "nix-command flakes";

  programs.zsh.enable = true;

  system.configurationRevision = self.rev or self.dirtyRev or null;

  environment.systemPackages = packages.tools ++ packages.devTools ++ packages.lsp;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";
}
