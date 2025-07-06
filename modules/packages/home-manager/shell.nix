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
      "nix-rebuild" = "sudo nixos-rebuild switch --flake ~/.config/nix-config";
      "dw-rebuild" = "sudo darwin-rebuild switch --flake ~/.config/nix-config/#macos";

      # git
      "gst" = "git status";
      "glo" = "git log --oneline";
    };
    syntaxHighlighting = {
      enable = true;
      highlighters = ["brackets" "cursor" "pattern" "regexp"];
    };
  };

  programs.starship = {
    enable = true;
    settings = {
      format = "$username$hostname$directory$git_branch$git_commit$git_state$git_metrics$git_status$hg_branch$line_break$character";
      right_format = "$c$cobol$daml$dart$deno$dotnet$elixir$elm$erlang$fennel$gleam$golang$guix_shell$haskell$haxe$helm$java$julia$kotlin$gradle$lua$nim$nodejs$ocaml$opa$perl$php$pulumi$purescript$python$quarto$raku$rlang$red$ruby$rust$scala$solidity$swift$terraform$typst$vlang$vagrant$zig$buf$nix_shell$conda$meson$spack$cmd_duration";
      aws.disabled = true;
      cmd_duration.min_time = 500;
      directory.truncation_length = 2;
      docker_context.disabled = true;
      gcloud.disabled = true;
      package.disabled = true;
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
