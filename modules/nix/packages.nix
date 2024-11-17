{pkgs, ...}: {
  common = with pkgs; [
    alejandra
    arp-scan
    btop
    cloc
    dnsutils
    home-manager
    inetutils
    jq
    killall
    openssl
    ripgrep
    unzip
    zip
  ];

  devTools = with pkgs; [
    dune_3
    flyctl
    gnumake
    go
    luajit
    lua-language-server
    neovim
    nil
    # nodejs_22
    # nodePackages.pnpm
    ocamlPackages.utop
    python3Minimal
    rust-bin.stable.latest.default
    stylua
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
