{
  args,
  pkgs,
  vars,
  ...
}:
let
  modulesPath = ../../modules/packages/home-manager;
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

    gtk = {
      enable = true;
      iconTheme = {
        package = pkgs.rose-pine-icon-theme;
        name = "rose-pine";
      };
      cursorTheme = {
        name = "BreezeX-RosePine-Linux";
        package = pkgs.rose-pine-cursor;
      };
      colorScheme = "dark";
      font.name = "Inter";
      theme = {
        package = pkgs.colloid-gtk-theme.override {
          tweaks = [
            "dracula"
            "rimless"
          ];
        };
        name = "Colloid-Dark-Dracula";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "adwaita";
      style = {
        name = "adwaita";
        package = pkgs.adwaita-qt;
      };
    };

    programs.walker = {
      enable = true;
      runAsService = true;
    };

    xdg.desktopEntries.spotify = {
      name = "Spotify";
      genericName = "Music Player";
      exec = "spotify_player";
      icon = "/home/sheke/Pictures/icons/spotify.png";
      terminal = true;
      type = "Application";
    };

    services.playerctld.enable = true;
  };
}
