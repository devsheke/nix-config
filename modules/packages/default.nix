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
