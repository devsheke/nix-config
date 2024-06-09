{osIcon, ...}: {pkgs, ...}: {
  programs.fastfetch = with pkgs; {
    enable = true;
    package = fastfetch;
    settings = {
      display.separator = "  ";
      modules = [
        {
          type = "title";
          format = "┌──────────────── {1}@{2} ─────────────────┐";
        }
        {
          type = "host";
          key = "  󰇄";
        }
        {
          type = "os";
          key = "  ${osIcon}";
          format = "{3} {10} {8}";
        }
        {
          type = "kernel";
          key = "  ";
          format = "{1} {2}";
        }
        {
          type = "cpu";
          key = "  ";
        }
        {
          type = "memory";
          key = "  󰑭";
          format = "{1} / {2}";
        }
        {
          type = "display";
          key = "  󰍹";
          format = "{1}x{2} @ {3}";
        }
        {
          type = "de";
          key = "  ";
        }
        {
          type = "wm";
          key = "  ";
        }
        {
          type = "terminal";
          key = "  ";
        }
        {
          type = "terminalfont";
          key = "  ";
          format = "{2}";
        }
        {
          type = "packages";
          key = "  󰏖";
        }
        {
          type = "uptime";
          key = "  󰅐";
        }
        {
          type = "localip";
          key = "  󰩟";
          "compact" = true;
        }
        {
          type = "custom";
          format = "└────────────────────────────────────────────┘";
        }
        {
          type = "colors";
          paddingLeft = 2;
          symbol = "circle";
        }
      ];
    };
  };
}
