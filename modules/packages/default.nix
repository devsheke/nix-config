{ pkgs, ... }:
{
  defaults = with pkgs; [
    alejandra
    arp-scan
    btop
    cloc
    chafa
    dnsutils
    ffmpeg
    fd
    git
    ghostscript_headless
    home-manager
    imagemagick
    inetutils
    killall
    lsof
    neovim
    poppler-utils
    p7zip
    ripgrep
    tree-sitter
    unar
    unzip
    yt-dlp
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
