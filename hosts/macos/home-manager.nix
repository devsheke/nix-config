{vars, ...}: let
  modulesPath = ../../modules/packages/home-manager;
in {
  home-manager.users.${vars.user} = {
    imports = [
      # (modulesPath + "/ghostty.nix")
      (modulesPath + "/git.nix")
      (modulesPath + "/nvim.nix")
      (modulesPath + "/shell.nix")
      (modulesPath + "/tmux.nix")
    ];

    home = {
      username = vars.user;
      homeDirectory = "/Users/${vars.user}";
      stateVersion = "25.05";
    };
  };
}
