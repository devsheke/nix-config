{
  inputs,
  pkgs,
  vars,
  ...
}: let
  modulesPath = ../../modules/packages/home-manager;
in {
  home-manager.extraSpecialArgs = {inherit inputs;};
  home-manager.users.${vars.user} = {lib, ...}: {
    imports = [
      inputs.dms.homeModules.dank-material-shell
      (modulesPath + "/ghostty.nix")
      (modulesPath + "/git.nix")
      (modulesPath + "/nvim.nix")
      (modulesPath + "/shell.nix")
      (modulesPath + "/rose-pine-shell.nix")
      (modulesPath + "/tmux.nix")
    ];

    home = {
      username = vars.user;
      homeDirectory = "/home/${vars.user}";
      stateVersion = "26.05";
    };

    xdg.configFile."uwsm/env-hyprland".text = ''
      export AQ_DRM_DEVICES=/dev/dri/intel-igpu
      export GSK_RENDERER=gl
      export __EGL_VENDOR_LIBRARY_FILENAMES=/run/opengl-driver/share/glvnd/egl_vendor.d/50_mesa.json
    '';

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };
    };

    qt = {
      enable = true;
      style.name = "kvantum";
    };

    programs.rose-pine-shell.enable = true;

    home.packages = [pkgs.kdePackages.dolphin];
    # The absolute launcher also works before the full system profile is switched.
    xdg.dataFile."applications/org.kde.dolphin.desktop".source = let
      launcher = pkgs.makeDesktopItem {
        name = "org.kde.dolphin";
        desktopName = "Dolphin";
        genericName = "File Manager";
        exec = "${pkgs.kdePackages.dolphin}/bin/dolphin %u";
        icon = "org.kde.dolphin";
        terminal = false;
        categories = ["Qt" "KDE" "System" "FileManager"];
        mimeTypes = ["inode/directory"];
      };
    in "${launcher}/share/applications/org.kde.dolphin.desktop";
    # Keep mimeapps.list writable and retain the user's unrelated associations.
    home.activation.dolphinDefault = lib.hm.dag.entryAfter ["linkGeneration"] ''
      run ${pkgs.xdg-utils}/bin/xdg-mime default org.kde.dolphin.desktop inode/directory
    '';

    services.playerctld.enable = true;

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = pkgs.lib.mkForce "qt5ct;qt6ct";
    };

    stylix.targets.ghostty.enable = false;
    stylix.targets.starship.enable = false;
    stylix.targets.tmux.enable = false;
    stylix.targets.qt = {
      enable = true;
      platform = "qtct";
    };
    stylix.targets.zen-browser = {
      enable = true;
      profileNames = ["Default Profile"];
    };

    services.xembed-sni-proxy = {
      enable = true;
      package = pkgs.kdePackages.plasma-workspace;
    };
  };
}
