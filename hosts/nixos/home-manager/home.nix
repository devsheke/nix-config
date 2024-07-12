{
  outputs,
  pkgs,
  ...
}: let
  homeModules = ../../../modules/home-manager;
  shellModules = homeModules + "/shell";
  osIcon = "󱄅";
in {
  imports =
    [
      ./programs/i3.nix
      ./programs/picom.nix
      (homeModules + "/alacritty.nix")
    ]
    ++ [
      (shellModules + "/bat.nix")
      (shellModules + "/eza.nix")
      (shellModules + "/fzf.nix")
      (shellModules + "/git.nix")
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
    homeDirectory = "/home/sheke";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  home.pointerCursor = {
    x11.enable = true;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  gtk = {
    enable = true;
    font.name = "Noto Sans";
    cursorTheme = {
      package = pkgs.rose-pine-cursor;
      name = "BreezeX-RosePine-Linux";
    };
    iconTheme = {
      package = pkgs.rose-pine-icon-theme;
      name = "rose-pine";
    };
    theme = {
      package = pkgs.rose-pine-gtk-theme;
      name = "rose-pine";
    };
  };

  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.11";
}
