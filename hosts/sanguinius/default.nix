# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  args,
  pkgs,
  vars,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    args.stylix.nixosModules.stylix
    ./stylix.nix
    (import ./home-manager.nix {
      inherit args vars pkgs;
    })
    (import ./packages.nix { inherit args pkgs; })
    ./services.nix
    ./virtualisation.nix
  ];

  nix.settings.experimental-features = "nix-command flakes";

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [ (import ../../overlays/virtiofsd.nix) ];
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking = {
    hostName = "sanguinius"; # Define your hostname.
    networkmanager = {
      enable = true;
      dns = "none";
    };
    nameservers = [
      "1.1.1.1"
      "194.242.2.4"
    ];
  };

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

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvpl
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sheke = {
    isNormalUser = true;
    description = "sheke";
    extraGroups = [
      "docker"
      "input"
      "networkmanager"
      "wheel"
      "libvirtd"
      "kvm"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
  };

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
