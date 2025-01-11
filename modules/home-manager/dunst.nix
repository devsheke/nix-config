{pkgs, ...}: let
  rosePine = (import ../rose-pine.nix {}).main;
in {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
      size = "32x32";
    };
    settings = with rosePine; {
      global = {
        browser = "${pkgs.xdg-utils}/bin/xdg-open";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
        follow = "mouse";
        format = "<b>%s</b>\\n%b";
        frame_color = highlightMed;
        frame_width = 2;
        geometry = "500x5-5+30";
        height = 100;
        width = 350;
        horizontal_padding = 8;
        icon_position = "left";
        min_icon_size = 32;
        max_icon_size = 64;
        line_height = 0;
        markup = "full";
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        transparency = 0;
        word_wrap = true;
        font = "Overpass Nerd Font Propo 12";
        vertical_alignment = "center";
      };

      urgency_low = {
        background = surface;
        foreground = text;
        frame_color = highlightHigh;
        timeout = 5;
      };

      urgency_normal = {
        background = surface;
        foreground = text;
        frame_color = highlightHigh;
        timeout = 5;
      };

      urgency_critical = {
        background = surface;
        foreground = text;
        frame_color = love;
        timeout = 5;
      };

      shortcuts = {
        context = "mod4+grave";
        close = "mod4+shift+space";
      };
    };
  };
}
