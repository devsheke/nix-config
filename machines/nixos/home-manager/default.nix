{
  outputs,
  pkgs,
  ...
}: let
  homeModules = ../../../modules/home-manager;
  args = {
    osIcon = "";
    pkgs = pkgs;
  };
in {
  imports = [
    ./i3.nix
    ./picom.nix
    (homeModules + "/rose-pine-qbittorrent.nix")
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
    gtk.enable = true;
    name = "BreezeX-RosePine-Linux";
    package = pkgs.rose-pine-cursor;
    size = 24;
  };

  dconf = {
    enable = true;
    settings = {
      "org/gnome/desktop/interface" = {
        gtk-theme = "rose-pine";
        color-scheme = "prefer-dark";
      };
    };
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
    gtk3 = {
      extraConfig.gtk-application-prefer-dark-theme = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "rose-pine";
      package = pkgs.rose-pine-gtk-theme;
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
