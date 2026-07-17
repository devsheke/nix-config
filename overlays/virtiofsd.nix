final: prev: {
  virtiofsd = prev.rustPlatform.buildRustPackage rec {
    pname = "virtiofsd";
    version = "8fa5564fdd4d5296997fb054a5e3193e18a81bcf";

    src = prev.fetchFromGitLab {
      owner = "hreitz";
      repo = "virtiofsd-rs";
      rev = version;
      hash = "sha256-QjLOjH+AvF3I9ffLTRhEfwRKG7SIjTy9kQv3Q/it+hs=";
    };

    cargoHash = "sha256-reaVHbfrHj5iZjpRaB+nREctoS3ZLdl5WGIurpRqjZU=";
    separateDebugInfo = true;

    buildInputs = with prev; [
      libcap_ng
      libseccomp
    ];
    LIBCAPNG_LIB_PATH = "${prev.lib.getLib prev.libcap_ng}/lib";

    postConfigure = ''
      sed -i "s|/usr/libexec|$out/bin|g" 50-virtiofsd.json
    '';
    postInstall = ''
      install -Dm644 50-virtiofsd.json "$out/share/qemu/vhost-user/50-virtiofsd.json"
    '';
  };
}
