{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      ignoreAllDups = true;
      size = 10000;
      share = true;
    };
    initExtra = ''
      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward
      export MANPAGER='nvim +Man!'
    '';
    shellAliases = {
      gst = "git status";
      gl = "git log";
      glo = "git log --oneline";
      gco = "git checkout";
      gonew = "go mod init";
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
    colors = {
      bg = "#faf4ed";
      "bg+" = "#f2e9e1";
      border = "#dfdad9";
      fg = "#797593";
      "fg+" = "#575279";
      gutter = "#faf4ed";
      hl = "#d7827e";
      "hl+" = "#d7827e";
      header = "#286983";
      info = "#56949f";
      marker = "#b4637a";
      pointer = "#907aa9";
      prompt = "#797593";
      separator = "#403d52";
      spinner = "#ea9d34";
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
