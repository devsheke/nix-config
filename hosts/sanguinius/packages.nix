{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  apps = import ../../modules/packages pkgs;
  chatgpt = pkgs.callPackage ./chatgpt.nix { };
  system = "x86_64-linux";
  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp = pkg: desktopName: (patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload ");
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
      discord
      fastfetch
      grimblast
      guestfs-tools
      heroic
      hyprlock
      hyprshutdown
      keepassxc
      libinput-gestures
      looking-glass-client
      mpv
      networkmanagerapplet
      inputs.matugen.packages.${system}.default
      obsidian
      onlyoffice-desktopeditors
      openvpn
      pavucontrol
      polkit_gnome
      satty
      seahorse
      spotify
      swaybg
      swaynotificationcenter
      tigervnc
      kdePackages.dolphin
      virtiofsd
      wl-clipboard
      waybar
      xarchiver
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      pkgs.sddm-astronaut
      mkcert
      nssTools
      (GPUOffloadApp pkgs.steam "steam")
      (GPUOffloadApp pkgs.heroic "com.heroicgameslauncher.hgl")
    ]);

  programs.localsend.enable = true;
  programs.steam.enable = true;
  # Optional: explicitly enable firewall opening (default is true)
  # programs.localsend.openFirewall = true;
}
