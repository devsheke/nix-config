{outputs, ...}: let
  homeModules = ../../../modules/home-manager;
  shellModules = homeModules + "/shell";
  osIcon = "󰀵";
in {
  imports =
    [
      (homeModules + "/alacritty.nix")
      (homeModules + "/nvim.nix")
    ]
    ++ [
      (shellModules + "/bat.nix")
      (shellModules + "/eza.nix")
      (shellModules + "/fzf.nix")
      (shellModules + "/git.nix")
      (shellModules + "/nnn.nix")
      (shellModules + "/tmux.nix")
      (shellModules + "/zsh.nix")
      (import (shellModules + "/fastfetch.nix") {osIcon = osIcon;})
      (import (shellModules + "/starship.nix") {osIcon = osIcon;})
    ];

  nixpkgs = {
    overlays = [
      outputs.overlays.stable-packages
    ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "sheke";
    homeDirectory = "/Users/sheke";
  };
  programs.home-manager.enable = true;

  programs.alacritty.settings.font.size = 11.0;

  home.stateVersion = "24.05";
}
