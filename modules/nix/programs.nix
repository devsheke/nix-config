{pkgs, ...}: {
  tools = with pkgs; [
    arp-scan
    btop
    cloc
    dnsutils
    inetutils
    jq
    killall
    ripgrep
    unzip
    zip
  ];

  devTools = with pkgs; [
    air
    dune_3
    git
    go
    goimports
    golines
    gnumake
    clang
    nodejs_22
    nodePackages.pnpm
    ocaml
    ocamlPackages.utop
    opam
    openssl
    postgresql
    flyctl
    pyenv
    python312
    python312Packages.pip
    sqlc
    stable.neovim
    rust-bin.stable.latest.default
  ];

  lsp = with pkgs; [
    alejandra
    elixir-ls
    eslint_d
    golangci-lint
    golangci-lint-langserver
    gopls
    lua-language-server
    nil
    nodePackages.eslint
    nodePackages.bash-language-server
    nodePackages.typescript-language-server
    nodePackages.vscode-json-languageserver
    ocamlPackages.lsp
    ocamlPackages.ocamlformat
    ocamlPackages.odoc
    prettierd
    python312Packages.black
    python312Packages.pyflakes
    python312Packages.pyls-isort
    python312Packages.python-lsp-server
    rust-analyzer
    stylua
    svelte-language-server
    tailwindcss-language-server
    taplo
    templ
    yaml-language-server
  ];

  guis = with pkgs; [
    alacritty
    brave
    celluloid
    discord-screenaudio
    flameshot
    onlyoffice-bin_latest
    openvpn
    qbittorrent
    signal-desktop
    spotify
    thunderbird
    xfce.thunar
  ];
}
