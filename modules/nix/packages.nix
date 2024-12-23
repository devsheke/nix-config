{pkgs, ...}: {
  common = with pkgs; [
    alejandra
    arp-scan
    btop
    cloc
    dnsutils
    home-manager
    inetutils
    killall
    openssl
    p7zip
    ripgrep
    unzip
    zip
  ];

  devTools = with pkgs; [
    flyctl
    gcc
    gnumake
    luajit
    neovim
    nil
    python3Minimal
    taplo
  ];

  linuxEssentials = with pkgs; [
    alacritty
    firefox-beta
    keepassxc
    onlyoffice-bin_latest
    openvpn
    qbittorrent
    remmina
    spotify
    thunderbird
    ungoogled-chromium
  ];
}
