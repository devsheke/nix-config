{pkgs, ...}: let
  notoFonts = "Noto Sans";
  fontAwesome = "Font Awesome 6 Free";
  rosePine = {
    highlightMed = "#403d52";
    love = "#eb6f92";
    overlay = "#26233a";
    subtle = "#908caa";
    white = "#ffffff";
    dawnFoam = "#56949f";
    dawnLove = "#b4637a";
    moonHighlightMed = "#44415a";
    moonOverlay = "#393552";
    moonSurface = "#2a273f";
  };
in {
  xsession.windowManager.i3 = rec {
    enable = true;
    config = {
      modifier = "Mod4";
      bars = [];
      assigns = {
        "1" = [{class = "Alacritty";}];
        "2" = [{class = "Brave";} {class = "firefox";}];
        "4" = [{class = "Spotify";}];
        "5" = [{class = "terminal64.exe";}];
      };
      workspaceOutputAssign = [
        {
          workspace = "1";
          output = "HDMI-0";
        }
        {
          workspace = "2";
          output = "VGA-0";
        }
      ];
      colors = {
        focused = with rosePine; {
          background = overlay;
          border = moonHighlightMed;
          childBorder = subtle;
          indicator = subtle;
          text = white;
        };

        focusedInactive = with rosePine; {
          background = moonOverlay;
          border = moonSurface;
          childBorder = highlightMed;
          indicator = highlightMed;
          text = dawnFoam;
        };

        unfocused = with rosePine; {
          background = moonOverlay;
          border = moonSurface;
          childBorder = highlightMed;
          indicator = highlightMed;
          text = dawnFoam;
        };

        urgent = with rosePine; {
          background = love;
          border = dawnLove;
          childBorder = dawnLove;
          indicator = dawnLove;
          text = white;
        };

        background = rosePine.overlay;
      };
      floating.criteria = [
        {class = "pavucontrol";}
        {class = "Steam";}
        {class = "Signal";}
        {class = "Spotify";}
        {class = "nvidia-settings";}
        {class = "Thunar";}
        {class = ".blueman-manager-wrapped";}
        {class = "KeePassXC";}
        {class = "flameshot";}
      ];
      fonts = {
        names = ["Noto Sans"];
        style = "Medium";
        size = 8.5;
      };
      gaps.inner = 10;
      keybindings = {
        # i3
        "${config.modifier}+Shift+c" = "reload";
        "${config.modifier}+Shift+r" = "restart";
        "${config.modifier}+Shift+q" = "exit";
        "${config.modifier}+q" = "kill";

        # Apps
        "${config.modifier}+Return" = "exec alacritty";
        "${config.modifier}+w" = "exec brave";
        "${config.modifier}+d" = "exec thunar";
        "${config.modifier}+space" = "exec rofi -show drun";
        "${config.modifier}+c" = "exec rofi -show calc";
        "Ctrl+Shift+l" = "exec dm-tool lock";

        # Windows
        "${config.modifier}+f" = "floating toggle";
        "${config.modifier}+h" = "focus left";
        "${config.modifier}+l" = "focus right";
        "${config.modifier}+j" = "focus down";
        "${config.modifier}+k" = "focus up";
        "${config.modifier}+Shift+h" = "move left";
        "${config.modifier}+Shift+l" = "move right";
        "${config.modifier}+Shift+j" = "move down";
        "${config.modifier}+Shift+k" = "move up";

        # Workspaces
        "${config.modifier}+1" = "workspace 1";
        "${config.modifier}+2" = "workspace 2";
        "${config.modifier}+3" = "workspace 3";
        "${config.modifier}+4" = "workspace 4";
        "${config.modifier}+5" = "workspace 5";
        "${config.modifier}+6" = "workspace 6";
        "${config.modifier}+Shift+1" = "move to workspace 1";
        "${config.modifier}+Shift+2" = "move to workspace 2";
        "${config.modifier}+Shift+3" = "move to workspace 3";
        "${config.modifier}+Shift+4" = "move to workspace 4";
        "${config.modifier}+Shift+5" = "move to workspace 5";
        "${config.modifier}+Shift+6" = "move to workspace 6";

        # Media
        # "XF86AudioRaiseVolume" = "";
        # "XF86AudioLowerVolume" = "";
        # "XF86AudioPlay" = "";
      };
      terminal = "alacritty";
      startup = [
        {
          command = "--no-startup-id ~/.fehbg";
        }
        {
          command = "--no-startup-id ~/.screenlayout/default.sh";
        }
        {
          command = "--no-startup-id autotiling";
          always = true;
        }
        {
          command = "--no-startup-id flameshot";
          always = true;
        }
        {command = "polybar top";}
        {command = "blueman-applet";}
        {command = "keepassxc";}
        {command = "alacritty";}
        {command = "brave";}
      ];
    };
  };

  services.polybar = {
    enable = true;
    script = "polybar top &";
    package = pkgs.polybar.override {
      i3Support = true;
    };
    config = {
      "bar/top" = {
        monitor = "\${env:MONITOR:HDMI-0}";
        width = "100%";
        height = "3%";
        radius = 0;
        modules-left = "i3";
        modules-right = "temperature cpu memory tray date";
        "font-0" = "${notoFonts}:style=Bold:pixelsize=10;2";
        "font-1" = "${notoFonts}:style=Bold:pixelsize=10;2";
        "font-2" = "${fontAwesome}:style=Solid:pixelsize=10;3";
      };

      "module/cpu" = {
        type = "internal/cpu";
        label = "%{T3}%{T-} %percentage%%";
        label-padding-left = 2;
        label-padding-right = 2;
        interval = "0.5";
      };

      "module/date" = {
        type = "internal/date";
        internal = 5;
        date = "%a %d %b";
        time = "%H:%M";
        label = "%{T1}%time%  %date%%{T-}";
        label-padding = 4;
      };

      "module/i3" = {
        type = "internal/i3";
        show-urgent = true;
        index-sort = true;
        enable-scroll = true;
        wrapping-scroll = false;
      };

      "module/tray" = {
        type = "internal/tray";
        tray-spacing = 10;
      };

      "module/temperature" = {
        type = "internal/temperature";
        thermal-zone = 2;
        label-padding-right = 2;
        ramp-0 = "";
        ramp-1 = "";
        ramp-2 = "";
        format = "<ramp> <label>";
      };

      "module/memory" = {
        type = "internal/memory";
        label = "%{T3}%{T-} %gb_used%";
        label-padding-left = 2;
        label-padding-right = 4;
      };
    };
  };
}
