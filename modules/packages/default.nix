{ pkgs, ... }:
{
  defaults = with pkgs; [
    alejandra
    arp-scan
    btop
    cava
    cloc
    chafa
    dnsutils
    ffmpeg-full
    fd
    git
    ghostscript_headless
    home-manager
    imagemagick
    inetutils
    killall
    lsof
    neovim
    openssl
    poppler-utils
    p7zip
    python3
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
