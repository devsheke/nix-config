{...}: {
  xsession.windowManager.i3 = rec {
    enable = true;
    config = {
      modifier = "Mod1";
      assigns = {
        "2" = [{class = "Alacritty";}];
        "1" = [{class = "Brave";} {class = "firefox";}];
        "4" = [{class = "Signal";} {class = "Spotify";}];
      };
      bars = [];
      colors = {
        focused = {
          background = "#26233a";
          border = "#44415a";
          childBorder = "#908caa";
          indicator = "#908caa";
          text = "#ffffff";
        };

        focusedInactive = {
          background = "#393552";
          border = "#2a273f";
          childBorder = "#403d52";
          indicator = "#403d52";
          text = "#56949f";
        };

        unfocused = {
          background = "#393552";
          border = "#2a273f";
          childBorder = "#403d52";
          indicator = "#403d52";
          text = "#56949f";
        };

        urgent = {
          background = "#eb6f92";
          border = "#b4637a";
          childBorder = "#b4637a";
          indicator = "#b4637a";
          text = "#ffffff";
        };

        background = "#26233a";
      };
      floating.criteria = [
        {class = "Pavucontrol";}
        {class = "Steam";}
        {class = "Signal";}
        {class = "Spotify";}
        {class = "nvidia-settings";}
        {class = "Thunar";}
        {class = ".blueman-manager-wrapped";}
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
        "${config.modifier}+w" = "exec firefox-devedition";
        "${config.modifier}+d" = "exec thunar";
        "${config.modifier}+space" = "exec rofi -show run";
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
      };
      terminal = "alacritty";
      startup = [
        {
          command = "--no-startup-id flameshot";
          always = true;
        }
        {command = "blueman-applet";}
        {
          command = "/home/sheke/.config/eww/bar/scripts/i3ws/i3ws";
        }
        {command = "--no-startup-id eww daemon";}
        {command = "--no-startup-id eww open bar";}
        {
          command = "--no-startup-id autotiling";
          always = true;
        }
        {command = "alacritty";}
        {command = "firefox-devedition";}
      ];
    };
  };
}
