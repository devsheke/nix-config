# Download rose-pine themes for qBittorrent client
{pkgs, ...}: let
  rose-pine-theme = pkgs.fetchgit {
    url = "https://github.com/rose-pine/qbittorrent";
    hash = "sha256-C1i7JiEdtFCSGRRe/6zRomTLkKLdcUqiP969JIuFHxE=";
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
  xdg.configFile."qBittorrent/themes/rose-pine" = {
    source = copyTheme;
  };
}
