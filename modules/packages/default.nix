{pkgs, ...}: {
  defaults = with pkgs; [
    alejandra
    arp-scan
    btop
    cloc
    chafa
    dnsutils
    home-manager
    inetutils
    killall
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
