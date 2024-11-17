{pkgs, ...}: {
  programs.alacritty = with pkgs; {
    enable = true;
    package = alacritty;
    settings = {
      font.normal = {
        family = "GeistMono Nerd Font"; # or OverpassM Nerd Font
        style = "Regular";
      };

      colors.primary = {
        foreground = "#575279";
        background = "#faf4ed";
        dim_foreground = "#797593";
        bright_foreground = "#575279";
      };

      colors.cursor = {
        text = "#575279";
        cursor = "#cecacd";
      };

      colors.vi_mode_cursor = {
        text = "#575279";
        cursor = "#cecacd";
      };

      colors.search.matches = {
        foreground = "#797593";
        background = "#f2e9e1";
      };

      colors.search.focused_match = {
        foreground = "#faf4ed";
        background = "#d7827e";
      };

      colors.hints.start = {
        foreground = "#797593";
        background = "#fffaf3";
      };

      colors.hints.end = {
        foreground = "#9893a5";
        background = "#fffaf3";
      };

      colors.line_indicator = {
        foreground = "None";
        background = "None";
      };

      colors.footer_bar = {
        foreground = "#575279";
        background = "#fffaf3";
      };

      colors.selection = {
        text = "#575279";
        background = "#dfdad9";
      };

      colors.normal = {
        black = "#f2e9e1";
        red = "#b4637a";
        green = "#286983";
        yellow = "#ea9d34";
        blue = "#56949f";
        magenta = "#907aa9";
        cyan = "#d7827e";
        white = "#575279";
      };

      colors.bright = {
        black = "#9893a5";
        red = "#b4637a";
        green = "#286983";
        yellow = "#ea9d34";
        blue = "#56949f";
        magenta = "#907aa9";
        cyan = "#d7827e";
        white = "#575279";
      };

      colors.dim = {
        black = "#9893a5";
        red = "#b4637a";
        green = "#286983";
        yellow = "#ea9d34";
        blue = "#56949f";
        magenta = "#907aa9";
        cyan = "#d7827e";
        white = "#575279";
      };

      colors.indexed_colors = [
        {
          index = 16;
          color = "#955f61";
        }
      ];

      cursor.style = {
        shape = "Block";
        blinking = "Never";
      };

      window = {
        option_as_alt = "Both";
      };
    };
  };
}
