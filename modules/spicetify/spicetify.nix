{
  pkgs,
  spicetify-nix,
  ...
}: let
  spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
in {
  # import the flake's module for your system
  imports = [spicetify-nix.homeManagerModules.default];

  programs.spicetify = {
    enable = true;
    colorScheme = "rose-pine-moon";
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      lastfm
    ];
  };
}
