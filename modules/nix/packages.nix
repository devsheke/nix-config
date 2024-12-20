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
    brave
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
