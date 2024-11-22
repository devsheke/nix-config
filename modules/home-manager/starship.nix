{
  osIcon,
  pkgs,
  ...
}: let
  formatMain = "[▒▓](#56949f)[ ${osIcon} ](bg:#56949f fg:#f2e9e1)[](fg:#56949f)$sudo$localip$directory";
  formatGit = "$git_commit$git_state$git_metrics$git_status$git_branch";
  formatEnd = "$line_break$character";
  formatRightLangs = "$nix_shell$package$golang$nodejs$rust$c$lua$c$elixir$ocaml$python$zig";
  format_right_end = "$cmake$meson$status$battery$jobs$cmd_duration";
in {
  programs.starship = with pkgs; {
    enable = true;
    package = starship;
    settings = {
      format = formatMain + formatGit + "$docker_context" + formatEnd;
      right_format = "${formatRightLangs}${format_right_end}";
      hostname = {
        ssh_only = false;
        format = "(white) [$hostname](cyan)";
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
      git_branch.symbol = " ";
      golang.symbol = " ";
      hg_branch.symbol = " ";
      lua.symbol = " ";
      nix_shell.symbol = " ";
      nodejs.symbol = " ";
      package.symbol = "󰏖 ";
      python.symbol = " ";
      rust.symbol = " ";
      ocaml.symbol = " ";
    };
  };
}
