{pkgs, ...}: let
  rosePine = (import ../../modules/rose-pine.nix {}).main;
in {
  programs.alacritty = with pkgs; {
    enable = true;
    package = alacritty;
    settings = with rosePine; {
      font.normal = {
        family = "GeistMono Nerd Font"; # or OverpassM Nerd Font
        style = "Medium";
      };

      colors.primary = {
        foreground = text;
        background = base;
        dim_foreground = subtle;
        bright_foreground = text;
      };

      colors.cursor = {
        text = text;
        cursor = highlightHigh;
      };

      colors.vi_mode_cursor = {
        text = text;
        cursor = highlightHigh;
      };

      colors.search.matches = {
        foreground = subtle;
        background = overlay;
      };

      colors.search.focused_match = {
        foreground = base;
        background = rose;
      };

      colors.hints.start = {
        foreground = subtle;
        background = surface;
      };

      colors.hints.end = {
        foreground = muted;
        background = surface;
      };

      colors.line_indicator = {
        foreground = "None";
        background = "None";
      };

      colors.footer_bar = {
        foreground = text;
        background = surface;
      };

      colors.selection = {
        text = text;
        background = highlightMed;
      };

      colors.normal = {
        black = overlay;
        red = love;
        green = pine;
        yellow = gold;
        blue = foam;
        magenta = iris;
        cyan = rose;
        white = text;
      };

      colors.bright = {
        black = muted;
        red = love;
        green = pine;
        yellow = gold;
        blue = foam;
        magenta = iris;
        cyan = rose;
        white = text;
      };

      colors.dim = {
        black = muted;
        red = love;
        green = pine;
        yellow = gold;
        blue = foam;
        magenta = iris;
        cyan = rose;
        white = text;
      };

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
