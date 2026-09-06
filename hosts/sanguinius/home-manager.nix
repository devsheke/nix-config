{
  inputs,
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
      inputs.walker.homeManagerModules.default
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

    programs.walker = {
      enable = true;
      runAsService = true;
    };

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
      profileNames = [ "Default Profile" ];
    };

    services.xembed-sni-proxy = {
      enable = true;
      package = pkgs.kdePackages.plasma-workspace;
    };
  };
}
