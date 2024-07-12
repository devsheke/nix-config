{osIcon, ...}: {pkgs, ...}: let
  format_main = "[▒▓](#403d52)[ ${osIcon} ](bg:#403d52 fg:white)[](fg:#403d52)$sudo$localip$directory";
  format_git = "$git_commit$git_state$git_metrics$git_status$git_branch";
  format_end = "$line_break$character";
  format_right_langs = "$nix_shell$package$golang$nodejs$rust$c$lua$c$elixir$ocaml$python$zig";
  format_right_end = "$cmake$meson$status$battery$jobs$cmd_duration";
in {
  programs.starship = with pkgs; {
    enable = true;
    package = starship;
    settings = {
      format = format_main + format_git + "$docker_context" + format_end;
      right_format = "${format_right_langs}${format_right_end}";
      hostname = {
        ssh_only = false;
        format = "(blue) [$hostname](cyan)";
      };
      directory = {
        disabled = false;
        truncation_length = 2;
        format = "  (blue)[$path]($style)[$read_only]($read_only_style) ";
        read_only = " ";
      };
      aws.disabled = true;
      c.symbol = " ";
      docker_context.symbol = " ";
      elixir.symbol = " ";
      git_branch.symbol = " ";
      golang.symbol = " ";
      hg_branch.symbol = " ";
      lua.symbol = " ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = "󰏖 ";
      python.symbol = " ";
      rust.symbol = " ";
    };
  };
}
