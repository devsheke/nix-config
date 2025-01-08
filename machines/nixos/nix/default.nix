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
    displayManager = {
      lightdm = {
        enable = true;
        background = "/usr/share/backgrounds/background-image.jpg";
        greeters.gtk.enable = true;
      };
    };

    windowManager.dwm = {
      enable = true;
      package = pkgs.dwm.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "devsheke";
          repo = "dwm";
          rev = "d2503155ebabd7558099f5a20385ad8166c707d2";
          hash = "sha256-7MyshCCaPZu2pz8oLd/Q5dpbo683hTDRUnHD14PDcow=";
        };
      };
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
      arandr
      bc
      blueman
      celluloid
      dconf
      feh
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

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-lgc-plus
    font-awesome
    (nerdfonts.override {fonts = ["GeistMono" "JetBrainsMono" "Meslo"];})
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["JetBrainsMono Nerd Font" "GeistMono Nerd Font"];
      emoji = ["Noto Color Emoji"];
    };
  };

  services.openssh.enable = true;
  services.playerctld.enable = true;
  virtualisation.docker.enable = true;

  system.stateVersion = "24.05"; # Don't change this!
}
