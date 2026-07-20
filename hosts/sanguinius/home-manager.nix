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

    programs.elephant.package =
      let
        system = pkgs.stdenv.hostPlatform.system;
        elephant-overridden = args.elephant.packages.${system}.elephant.overrideAttrs (oldAttrs: {
          vendorHash = "sha256-ssX+ZQ6v+XcwC/RuIZ+rO/9zZwZnotudj8bvZNM7M3g=";
        });
        elephant-providers-overridden =
          args.elephant.packages.${system}.elephant-providers.overrideAttrs
            (oldAttrs: {
              vendorHash = "sha256-ssX+ZQ6v+XcwC/RuIZ+rO/9zZwZnotudj8bvZNM7M3g=";
            });
      in
      pkgs.symlinkJoin {
        name = "elephant-with-providers-2.22.0";
        paths = [
          elephant-overridden
          elephant-providers-overridden
        ];
      };

    programs.walker = {
      enable = true;
      runAsService = true;
    };

    services.playerctld.enable = true;

    stylix.targets.ghostty.enable = false;
    stylix.targets.starship.enable = false;
    stylix.targets.tmux.enable = false;
    stylix.targets.zen-browser = {
      enable = true;
      profileNames = [ "Default Profile" ];
    };
  };
}
