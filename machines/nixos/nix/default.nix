{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  rust-overlay,
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
    overlays = [outputs.overlays.stable-packages rust-overlay.overlays.default];
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
  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };
    displayManager = {
      lightdm = {
        enable = true;
        background = "/usr/share/backgrounds/background-image.jpg";
        greeters.gtk = {
          enable = true;
          theme = {
            package = pkgs.rose-pine-gtk-theme;
            name = "rose-pine-moon";
          };
          iconTheme = {
            package = pkgs.rose-pine-icon-theme;
            name = "rose-pine-moon";
          };
          cursorTheme = {
            package = pkgs.rose-pine-cursor;
            name = "BreezeX-RosePineDawn-Linux";
          };
        };
      };
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        arandr
        autotiling
        feh
        rofi
        rofi-power-menu
        xclip
        xorg.xev
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
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
      bc
      blueman
      celluloid
      dconf
      flameshot
      pandoc
      pavucontrol
      stable.wineWowPackages.stable
      xfce.thunar
    ]
    ++ packages.common
    ++ packages.devTools
    ++ packages.linuxEssentials;

  users.users.sheke = {
    isNormalUser = true;
    extraGroups = ["wheel" "networkmanager" "docker"];
    password = "password";
    shell = pkgs.zsh;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-lgc-plus
    font-awesome
    (nerdfonts.override {fonts = ["GeistMono" "Overpass"];})
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["GeistMono Nerd Font" "OverpassM Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };

  services.openssh.enable = true;
  services.playerctld.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "24.05"; # Don't change this!
}
