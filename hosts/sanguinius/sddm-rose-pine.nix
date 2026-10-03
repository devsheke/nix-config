{
  lib,
  stdenvNoCC,
  kdePackages,
  formats,
  wallpaper,
}: let
  wallpaperConfig = (formats.ini {}).generate "sddm-wallpaper.conf" {
    General.Background = "Backgrounds/current-wallpaper.png";
  };
in
  stdenvNoCC.mkDerivation {
    pname = "sddm-rose-pine-glass";
    version = "1.0";
    src = ./sddm-theme;
    dontBuild = true;
    propagatedBuildInputs = with kdePackages; [qtsvg.out qtvirtualkeyboard.out];

    installPhase = ''
      runHook preInstall
      theme_dir="$out/share/sddm/themes/rose-pine-glass"
      mkdir -p "$theme_dir"
      cp -r ./. "$theme_dir/"
      chmod -R u+w "$theme_dir"
      mkdir -p "$theme_dir/Backgrounds"
      cp ${wallpaper} "$theme_dir/Backgrounds/current-wallpaper.png"
      cp ${wallpaperConfig} "$theme_dir/theme.conf.user"
      runHook postInstall
    '';

    meta = {
      description = "Editable Rosé Pine Glass SDDM theme";
      license = lib.licenses.gpl3Plus;
      platforms = lib.platforms.linux;
    };
  }
