{...}: {
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      ignoreAllDups = true;
      size = 10000;
    };
    initExtra = ''
      export PATH="$PATH:$HOME/go/bin"
    '';
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
    };
    shellAliases = {
      dot = "ls ~/.config | fzf -i | xargs -n 1 nvim";
      code = "ls ~/Code | fzf -i | xargs -n 1 nvim";
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = ["brackets" "cursor"];
    };
  };

  programs.zoxide.enable = true;
}
