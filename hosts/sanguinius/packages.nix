{ pkgs, inputs, ... }:
let
  apps = import ../../modules/packages pkgs;
  chatgpt = pkgs.callPackage ./chatgpt.nix {};
in
{
  programs.direnv = {
    enable = true;
    loadInNixShell = true;
    nix-direnv.enable = true;
  };

  programs.uwsm.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.nix-ld.enable = true;

  programs.thunar.plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];

  programs.xfconf.enable = true;

  programs.zsh.enable = true;

  environment.systemPackages =
    with apps;
    defaults
    ++ devTools
    ++ (with pkgs; [
      antigravity-cli
      adwaita-qt6
      libsForQt5.qt5ct
      kdePackages.qt6ct
      libsForQt5.qtstyleplugin-kvantum
      kdePackages.qtstyleplugin-kvantum
      bubblewrap
      brave
      brightnessctl
      celluloid
      chatgpt
      claude-code
      # davinci-resolve
      discord
      fastfetch
      firefox
      grimblast
      guestfs-tools
      hyprlock
      hyprshutdown
      keepassxc
      kooha
      libinput-gestures
      looking-glass-client
      mpv
      networkmanagerapplet
      ngrok
      obs-studio
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
      tigervnc
      thunar
      virtiofsd
      wl-clipboard
      waybar
      xarchiver
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.sddm-astronaut
    ]);

  programs.localsend.enable = true;
  # Optional: explicitly enable firewall opening (default is true)
  # programs.localsend.openFirewall = true;
}
