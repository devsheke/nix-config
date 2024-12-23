{pkgs, ...}: let
  rosePine = (import ../rose-pine.nix {}).main;
in {
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    defaultKeymap = "emacs";
    enableCompletion = true;
    history = {
      ignoreAllDups = true;
      size = 10000;
      share = true;
    };
    initExtra = ''
      export MANPAGER='nvim +Man!'

      bindkey '^[[A' history-search-backward
      bindkey ';5A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey ';5B' history-search-forward

      bindkey ';5C' forward-word
      bindkey ';5D' backward-word
    '';
    oh-my-zsh = {
      enable = true;
      plugins = ["gh" "git" "golang"];
    };
    shellAliases = {
      "nix-rebuild" = "sudo nixos rebuild ~/.config/nix-config";
      "dw-rebuild" = "darwin rebuild ~/.config/nix-config";
      pyenv = "python3 -m venv .venv";
      cloci = "cloc --exclude-dir=target,node_modules,build,dist,tmp,_build,.direnv --exclude-ext=yaml,json,toml,.envrc ./";
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = ["brackets" "cursor" "pattern" "regexp"];
    };
  };

  programs.eza = {
    enable = true;
    extraOptions = [
      "--group-directories-first"
    ];
    git = true;
    icons = "auto";
  };

  programs.fzf = {
    enable = true;
    colors = with rosePine; {
      bg = base;
      "bg+" = overlay;
      border = highlightMed;
      fg = subtle;
      "fg+" = foam;
      gutter = base;
      hl = rose;
      "hl+" = rose;
      header = pine;
      info = foam;
      marker = love;
      pointer = iris;
      prompt = subtle;
      separator = highlightMed;
      spinner = gold;
    };
  };

  programs.git = {
    enable = true;
    userEmail = "abhi@sheke.tech";
    userName = "devsheke";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };

  programs.gh = with pkgs; {
    enable = true;
    extensions = [gh-dash gh-eco];
    settings.editor = "nvim";
  };

  programs.zoxide.enable = true;
}
