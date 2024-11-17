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
    ./i3.nix
    (homeModules + "/alacritty.nix")
    (homeModules + "/bat.nix")
    (homeModules + "/dunst.nix")
    (homeModules + "/nvim.nix")
    (homeModules + "/rofi.nix")
    (homeModules + "/shell.nix")
    (homeModules + "/tmux.nix")
    (import (homeModules + "/fastfetch.nix") args)
    (import (homeModules + "/starship.nix") args)
  ];

  nixpkgs = {
    overlays = [outputs.overlays.stable-packages];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "sheke";
    homeDirectory = "/home/sheke";
  };

  home.pointerCursor = {
    x11.enable = true;
    name = "BreezeX-RosePineDawn-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  gtk = {
    enable = true;
    font.name = "Noto Sans";
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePineDawn-Linux";
    };
    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine-dawn";
    };
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine-dawn";
    };
  };

  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
