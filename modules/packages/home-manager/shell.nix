{...}: {
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
    initContent = ''
      bindkey '^[[A' history-search-backward
      bindkey ';5A' history-search-backward
      bindkey '^[[B' history-search-forward
      bindkey ';5B' history-search-forward

      bindkey ';5C' forward-word
      bindkey ';5D' backward-word

      export MANPAGER='nvim +Man!'
    '';
    shellAliases = {
      "nix-rebuild" = "sudo nixos rebuild --flake ~/.config/nix-config";
      "dw-rebuild" = "sudo darwin-rebuild --flake ~/.config/nix-config";
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
  };

  programs.zoxide.enable = true;
}
