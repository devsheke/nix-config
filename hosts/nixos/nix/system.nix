{pkgs, ...}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  services.displayManager.defaultSession = "none+i3";
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm = {
        enable = true;
        background = "/home/sheke/Pictures/background-image.jpg";
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
    };
    desktopManager = {
      xterm.enable = false;
      wallpaper.mode = "fill";
    };
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        autotiling
        eww
        pavucontrol
        rofi
        xclip
        xorg.xev
      ];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk
    noto-fonts-lgc-plus
    font-awesome
    (nerdfonts.override {fonts = ["JetBrainsMono"];})
  ];

  fonts.fontconfig = {
    defaultFonts = {
      serif = ["Noto Serif"];
      sansSerif = ["Noto Sans"];
      monospace = ["JetBrainsMono Nerd Font"];
    };
  };
}
