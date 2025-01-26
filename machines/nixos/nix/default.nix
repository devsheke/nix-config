{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  ...
}: let
  packages = import ../../../modules/nix/packages.nix pkgs;
in {
  imports = [./hardware-configuration.nix];

  nixpkgs = {
    config = {
      allowUnfree = true;
      nvidia.acceptLicense = true;
    };
    overlays = [outputs.overlays.stable-packages];
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = ["nix-command flakes"];
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;

    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  security.polkit.enable = true;
  networking.networkmanager.enable = true;
  hardware.bluetooth = {
    enable = true; # enables support for Bluetooth
    powerOnBoot = true;
  };

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
  };

  services.xserver.displayManager.lightdm = {
    enable = true;
    background = "/usr/share/backgrounds/background-image.jpg";
    greeters.gtk = {
      enable = true;
      theme = {
        package = pkgs.rose-pine-gtk-theme;
        name = "rose-pine";
      };
      iconTheme = {
        package = pkgs.rose-pine-icon-theme;
        name = "rose-pine";
      };
      cursorTheme = {
        package = pkgs.rose-pine-cursor;
        name = "BreezeX-RosePine-Linux";
      };
    };
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = ./dwm;
    };
    extraSessionCommands = ''
      /home/sheke/.screenlayout/default.sh

      /home/sheke/.fehbg

      dash /home/sheke/.config/scripts/bar.sh &

      blueman-applet &
      nm-applet &
      keepassxc &
    '';
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable nix-ld for cross-compilation compatability.
  programs.nix-ld.enable = true;

  programs.zsh.enable = true;
  environment.pathsToLink = ["/share/zsh"];

  environment.systemPackages = with pkgs;
    [
      arandr
      bc
      blueman
      celluloid
      dash
      dconf
      feh
      imlib2
      networkmanagerapplet
      pavucontrol
      rofi
      xclip
      xorg.xev
    ]
    ++ packages.common
    ++ packages.devTools
    ++ packages.linuxEssentials;

  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  programs.thunar = {
    enable = true;
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  users.users.sheke = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs;
    [
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-lgc-plus
      font-awesome
    ]
    ++ (with pkgs.nerd-fonts; [geist-mono overpass]);

  fonts.fontconfig = {
    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["GeistMono Nerd Font" "OverpassM Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  services.openssh.enable = true;
  services.playerctld.enable = true;
  virtualisation.docker.enable = true;

  # systemd.user.services."dwm-startup" = {
  #   enable = true;
  #   description = "A startup script for dwm";
  #   path = with pkgs; [blueman dash feh keepassxc networkmanagerapplet xorg.xrandr];
  #   wantedBy = ["graphical-session.target"];
  #   partOf = ["graphical-session.target"];
  #   script = ''
  #     # configure screen outputs.
  #     /home/sheke/.screenlayout/default.sh
  #
  #     # configure wallpaper.
  #     /home/sheke/.fehbg
  #
  #     # start dwm bar.
  #     dash /home/sheke/.config/scripts/bar.sh &
  #
  #     # start tray items.
  #     blueman-applet &
  #     nm-applet &
  #     keepassxc &
  #   '';
  # };

  # Enable OpenGL
  hardware.graphics.enable = true;

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
  };

  services.xserver.videoDrivers = ["nvidia"];
  # Options to fix screen tearing issues
  services.xserver.screenSection = ''
    Option       "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option       "AllowIndirectGLXProtocol" "off"
    Option       "TripleBuffer" "on"
  '';

  system.stateVersion = "24.05"; # Don't change this!
}
