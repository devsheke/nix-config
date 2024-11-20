{pkgs, ...}: let
  rose-pine-theme = pkgs.git.cloneRepo {
    url = "";
    rev = "";
    name = "rose-pine-theme";
  };

  copyTheme =
    pkgs.runCommand "copyTheme" {
      buildInputs = [pkgs.coreutils];
    } ''
      mkdir -p $out;
      cp -r ${rose-pine-theme}/dist/* $out/;
    '';
in {
  home.packages = [copyTheme];
  home.file = {
    ".config/qbittorrent/themes/rose-pine" = {
      source = copyTheme;
    };
  };
}
