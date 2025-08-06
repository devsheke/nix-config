{ pkgs, ... }:
{
  defaults = with pkgs; [
    alejandra
    arp-scan
    btop
    cloc
    chafa
    dnsutils
    fd
    ghostscript_headless
    home-manager
    imagemagick
    inetutils
    killall
    neovim
    p7zip
    ripgrep
    unar
    unzip
    zip
  ];

  devTools = with pkgs; [
    neovim
    gcc
    gnumake
    lazygit
    luajit
    neovim
    nil
    taplo
  ];
}
