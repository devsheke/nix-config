{
  config,
  pkgs,
  ...
}: let
  rosePine = (import ../rose-pine.nix {}).moon;
in {
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-icon-theme;
      size = "32x32";
    };
    settings = with rosePine; {
      global = {
        browser = "${config.programs.brave.package}/bin/brave -new-tab";
        dmenu = "${pkgs.rofi}/bin/rofi -dmenu";
        follow = "mouse";
        format = "%i<b>%s</b>\\n%b";
        frame_color = highlightMed;
        frame_width = 2;
        geometry = "500x5-5+30";
        horizontal_padding = 8;
        icon_position = "left";
        line_height = 0;
        markup = "full";
        padding = 8;
        separator_color = "frame";
        separator_height = 2;
        transparency = 0;
        word_wrap = true;
        font = "Overpass Nerd Font Propo";
        content_alignment = "top";
      };

      urgency_low = {
        background = surface;
        foreground = text;
        frame_color = highlightHigh;
        timeout = 10;
      };

      urgency_normal = {
        background = surface;
        foreground = text;
        frame_color = highlightHigh;
        timeout = 15;
      };

      urgency_critical = {
        background = surface;
        foreground = text;
        frame_color = love;
        timeout = 0;
      };

      shortcuts = {
        context = "mod4+grave";
        close = "mod4+shift+space";
      };
    };
  };
}
