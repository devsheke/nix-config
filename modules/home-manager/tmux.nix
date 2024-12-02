{pkgs, ...}: {
  programs.tmux = with pkgs; {
    enable = true;
    sensibleOnTop = false;
    baseIndex = 1;
    clock24 = true;
    disableConfirmationPrompt = true;
    historyLimit = 50000;
    mouse = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    plugins = with pkgs; [
      {plugin = tmuxPlugins.sensible;}
      {plugin = tmuxPlugins.resurrect;}
      {plugin = tmuxPlugins.pain-control;}
      {plugin = tmuxPlugins.fuzzback;}
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'moon'

          set -g @rose_pine_directory 'on'
          set -g @rose_pine_date_time '%d/%m %H:%M'

          set -g @rose_pine_default_window_behavior 'on'
          set -g @rose_pine_show_current_program 'on'

          set -g @rose_pine_left_separator '  '
          set -g @rose_pine_right_separator '  '
          set -g @rose_pine_field_separator ' - '
          set -g @rose_pine_window_separator '  '

          set -g @rose_pine_session_icon ''
          set -g @rose_pine_current_window_icon ''
          set -g @rose_pine_folder_icon ''
          set -g @rose_pine_date_time_icon ''
          set -g @rose_pine_window_status_separator " | "

          set -gu default-command
          set -g default-shell "${pkgs.zsh}/bin/zsh"
        '';
      }
    ];
    extraConfig = ''
      set-option -ga terminal-overrides ',*:RGB'
    '';
  };
}
