{
  args,
  pkgs,
  vars,
  ...
}:
let
  modulesPath = ../../modules/packages/home-manager;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  home-manager.users.${vars.user} = {
    imports = [
      args.walker.homeManagerModules.default
      (modulesPath + "/ghostty.nix")
      (modulesPath + "/git.nix")
      (modulesPath + "/nvim.nix")
      (modulesPath + "/shell.nix")
      (modulesPath + "/tmux.nix")
      args.ags.homeManagerModules.default
    ];

    home = {
      username = vars.user;
      homeDirectory = "/home/${vars.user}";
      stateVersion = "26.05";
    };

    home.pointerCursor = {
      x11.enable = true;
      gtk.enable = true;
      name = "BreezeX-RosePine-Linux";
      package = pkgs.rose-pine-cursor;
      size = 24;
    };

    dconf.settings = {
      "org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    gtk = {
      enable = true;

      colorScheme = "dark";

      font.name = "Inter";

      iconTheme = {
        package = pkgs.papirus-icon-theme;
        name = "Papirus-Dark";
      };

      cursorTheme = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
      };

      theme = {
        name = "Nordic-darker";
        package = pkgs.nordic;
      };

      gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
      gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        name = "adwaita-dark";
        package = pkgs.adwaita-qt;
      };
    };

    programs.walker = {
      enable = true;
      runAsService = true;
    };

    programs.ags = {
      enable = true;
      configDir = null;
      extraPackages = [
        args.astal.packages.${system}.apps
        args.astal.packages.${system}.battery
        args.astal.packages.${system}.hyprland
        args.astal.packages.${system}.mpris
        args.astal.packages.${system}.network
        args.astal.packages.${system}.powerprofiles
        args.astal.packages.${system}.tray
        args.astal.packages.${system}.wireplumber
      ];
    };

    services.playerctld.enable = true;

    home.sessionVariables = {
      GTK_THEME = "Nordic-darker";
    };
  };
}
