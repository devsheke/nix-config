{pkgs, ...}: let
  packages = import ../../../modules/nix/packages.nix pkgs;
in {
  environment.systemPackages = packages.tools ++ packages.devTools ++ packages.lsp ++ packages.guis;

  environment.variables = {
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
  };
}
