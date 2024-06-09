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
    git
    elixir_1_15
    go
    gnumake
    clang
    nodejs_22
    nodePackages.pnpm
    openssl
    postgresql
    pyenv
    python312
    python312Packages.pip
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
    prettierd
    python312Packages.black
    python312Packages.pyflakes
    python312Packages.pyls-isort
    python312Packages.python-lsp-server
    stylua
    svelte-language-server
    tailwindcss-language-server
    taplo
    yaml-language-server
  ];

  guis = with pkgs; [
    alacritty
    brave
    celluloid
    openvpn
    signal-desktop
    spotify
    thunderbird
    xfce.thunar
  ];
}
