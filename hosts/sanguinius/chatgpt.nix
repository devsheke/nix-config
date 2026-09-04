{ pkgs, ... }:
let
  inherit (pkgs) lib stdenv;

  runtimeTools = with pkgs; [
    git
    glib.bin
    xdg-utils
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "chatgpt";
  version = "26.901.31953";

  src = pkgs.fetchurl {
    name = "chatgpt_amd64.deb";
    url = "https://persistent.oaistatic.com/codex-app-prod/linux/deb/pool/main/c/chatgpt/chatgpt_${finalAttrs.version}_amd64.deb";
    hash = "sha256-K7RSK+h33mwX5fTAcbBuxkiCsd0JqPC9IErwI6t1bZw=";
  };

  nativeBuildInputs = with pkgs; [
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    graphite2
    gtk3
    libdrm
    libgbm
    libusb1
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
  ];

  # Electron loads these libraries dynamically, so they are not visible in
  # the main executable's DT_NEEDED entries.
  runtimeDependencies = with pkgs; [
    libGL
    libnotify
    libpulseaudio
    libsecret
    pipewire
    speechd-minimal
    vulkan-loader
  ];

  dontBuild = true;
  dontStrip = true;
  dontWrapGApps = true;

  unpackPhase = ''
    runHook preUnpack

    dpkg-deb --extract "$src" .

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out"
    cp -r usr/bin usr/lib usr/share "$out/"

    runHook postInstall
  '';

  preFixup = ''
    # Electron's Crashpad and process.report implementations inspect the main
    # executable's program headers. Rewriting this unusually large ELF with
    # patchelf relocates PT_DYNAMIC and makes that inspection crash. Keep the
    # vendor executable intact and let this host's nix-ld load its libraries.
    rm "$out/bin/chatgpt"
    makeWrapper "$out/lib/chatgpt/codex-launcher" "$out/bin/chatgpt" \
      "''${gappsWrapperArgs[@]}" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath (finalAttrs.buildInputs ++ finalAttrs.runtimeDependencies)
      } \
      --prefix PATH : ${lib.makeBinPath runtimeTools}

    # This bundled executable has no usable ELF section table, so patchelf
    # cannot replace its Debian loader. Use Nix's native Tectonic build for
    # the app's LaTeX plugin instead.
    tectonic="$out/lib/chatgpt/resources/plugins/openai-bundled/plugins/latex/bin/tectonic"
    rm "$tectonic"
    ln -s ${lib.getExe pkgs.tectonic} "$tectonic"
  '';

  meta = {
    description = "ChatGPT desktop application by OpenAI";
    homepage = "https://developers.openai.com/codex/app";
    license = lib.licenses.unfree;
    mainProgram = "chatgpt";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
