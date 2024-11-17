{
  outputs,
  pkgs,
  ...
}: let
  homeModules = ../../../modules/home-manager;
  args = {
    osIcon = "󰀵";
    pkgs = pkgs;
  };
in {
  imports = [
    (homeModules + "/alacritty.nix")
    (homeModules + "/bat.nix")
    (homeModules + "/nvim.nix")
    (homeModules + "/shell.nix")
    (homeModules + "/tmux.nix")
    (import (homeModules + "/fastfetch.nix") args)
    (import (homeModules + "/starship.nix") args)
  ];

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [outputs.overlays.stable-packages];
  };

  home = {
    username = "sheke";
    homeDirectory = "/Users/sheke";
  };

  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.alacritty.settings.font.size = 12.0;

  home.stateVersion = "24.05";
}
