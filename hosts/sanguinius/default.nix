# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  args,
  config,
  pkgs,
  vars,
  ...
}:
let
  apps = import ../../modules/packages pkgs;
in
{
  imports = [
    ./hardware-configuration.nix
    (import ./home-manager.nix {
      inherit args vars pkgs;
    })
  ];

  nix.settings.experimental-features = "nix-command flakes";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "sanguinius"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
    theme = "catppuccin-mocha-mauve";
  };

  security.polkit.enable = true;
  security.pam.services.sddm.fprintAuth = true;
  security.pam.services.hyprlock.fprintAuth = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  services.thermald.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.fprintd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.blueman.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  programs.zsh.enable = true;
  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheke = {
    isNormalUser = true;
    description = "sheke";
    extraGroups = [
      "input"
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;
  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.xfconf.enable = true;
  environment.systemPackages =
    with apps;
    defaults
    ++ devTools
    ++ (with pkgs; [
      alacritty
      brave
      brightnessctl
      celluloid
      davinci-resolve
      discord
      fastfetch
      firefox
      grimblast
      hyprlock
      keepassxc
      kooha
      libinput-gestures
      networkmanagerapplet
      obsidian
      onlyoffice-desktopeditors
      opencode
      openvpn
      pavucontrol
      polkit_gnome
      satty
      seahorse
      spotify
      swaybg
      swaynotificationcenter
      waybar
      thunar
      wl-clipboard
      xarchiver
      args.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      (catppuccin-sddm.override {
        flavor = "mocha";
        accent = "mauve";
        font = "Inter";
        fontSize = "12";
        background = "/home/sheke/Pictures/sanguinius-motif.png";
        loginBackground = true;
      })
    ]);

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts
      nerd-fonts.geist-mono
      nerd-fonts.overpass
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      inter
      nerd-fonts.jetbrains-mono
      font-awesome
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [
          "Inter"
          "Noto Sans"
        ];
        monospace = [ "JetBrainsMono NFP" ];
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
