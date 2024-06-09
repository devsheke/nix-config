{...}: {
  programs.fzf = {
    enable = true;
    colors = {
      bg = "#191724";
      "bg+" = "#26233a";
      border = "#403d52";
      fg = "#908caa";
      "fg+" = "#e0def4";
      gutter = "#191724";
      hl = "#ebbcba";
      "hl+" = "#ebbcba";
      header = "#31748f";
      info = "#9ccfd8";
      marker = "#eb6f92";
      pointer = "#c4a7e7";
      prompt = "#908caa";
      separator = "#403d52";
      spinner = "#f6c177";
    };
    tmux.enableShellIntegration = true;
  };
}
