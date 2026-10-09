{pkgs, ...}: let
  inherit (pkgs) lib stdenv;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "helium";
    version = "0.19.2.1";

    src = pkgs.fetchurl {
      url = "https://github.com/imputnet/helium-linux/releases/download/${finalAttrs.version}/helium-${finalAttrs.version}-x86_64_linux.tar.xz";
      hash = "sha256-cHzzGeOj0qoGHKFddUh3vRi4sokghzjIKfywhzvH7Ns=";
    };

    nativeBuildInputs = with pkgs; [
      autoPatchelfHook
      # Wayland flags must expand from the session environment at launch.
      makeShellWrapper
      (wrapGAppsHook3.override {makeWrapper = makeShellWrapper;})
    ];

    buildInputs = with pkgs; [
      alsa-lib
      at-spi2-atk
      at-spi2-core
      cairo
      cups
      dbus
      expat
      glib
      gtk3
      libgbm
      libx11
      libxcb
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxkbcommon
      libxrandr
      nspr
      nss
      pango
      stdenv.cc.cc.lib
      systemd
      # Only runtime libraries are needed for the bundled Qt shims; mixing
      # the Qt 5 and Qt 6 development setup hooks causes a version conflict.
      (lib.getLib libsForQt5.qtbase)
      (lib.getLib kdePackages.qtbase)
    ];

    # Chromium loads these with dlopen rather than ELF dependencies.
    runtimeDependencies = map lib.getLib (with pkgs; [
      libGL
      libpulseaudio
      libsecret
      libva
      pipewire
      speechd-minimal
    ]);

    dontConfigure = true;
    dontBuild = true;
    dontStrip = true;
    dontWrapGApps = true;

    installPhase = ''
      runHook preInstall

      mkdir -p "$out/lib/helium" "$out/bin"
      cp -r . "$out/lib/helium/"

      install -Dm644 helium.desktop "$out/share/applications/helium.desktop"
      substituteInPlace "$out/share/applications/helium.desktop" \
        --replace-fail "Exec=helium" "Exec=$out/bin/helium"
      install -Dm644 product_logo_256.png \
        "$out/share/icons/hicolor/256x256/apps/helium.png"

      runHook postInstall
    '';

    preFixup = ''
      makeWrapper "$out/lib/helium/helium" "$out/bin/helium" \
        "''${gappsWrapperArgs[@]}" \
        --set CHROME_WRAPPER "$out/bin/helium" \
        --set CHROME_VERSION_EXTRA "nixos" \
        --prefix LD_LIBRARY_PATH : "$out/lib/helium:${lib.makeLibraryPath finalAttrs.runtimeDependencies}" \
        --suffix PATH : ${lib.makeBinPath [pkgs.xdg-utils pkgs.coreutils]} \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-wayland-ime=true}}"
    '';

    doInstallCheck = true;
    installCheckPhase = ''
      runHook preInstallCheck
      "$out/bin/helium" --version
      runHook postInstallCheck
    '';

    meta = {
      description = "Private, fast, and honest web browser based on Chromium";
      homepage = "https://helium.computer";
      license = with lib.licenses; [gpl3 bsd3];
      mainProgram = "helium";
      platforms = ["x86_64-linux"];
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
    };
  })
