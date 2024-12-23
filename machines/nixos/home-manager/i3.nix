{pkgs, ...}: let
  rosePine = (import ../../../modules/rose-pine.nix {}).main;
in {
  xsession.windowManager.i3 = rec {
    enable = true;
    config = {
      modifier = "Mod4";
      bars = with rosePine; [
        {
          colors = {
            activeWorkspace = {
              background = surface;
              border = highlightLow;
              text = muted;
            };
            background = base;
            bindingMode = {
              background = overlay;
              border = highlightMed;
              text = text;
            };
            focusedWorkspace = {
              background = highlightMed;
              border = highlightHigh;
              text = text;
            };
            inactiveWorkspace = {
              background = surface;
              border = highlightLow;
              text = muted;
            };
            statusline = text;
            urgentWorkspace = {
              background = love;
              border = rose;
              text = text;
            };
          };
          fonts = {
            names = ["Overpass Nerd Font Propo"];
            style = "Heavy";
            size = 9.0;
          };
          mode = "dock";
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs /home/sheke/.config/i3status-rust/config-default.toml";
          trayPadding = 4;
        }
      ];
      assigns = {
        "1" = [{class = "Alacritty";}];
        "2" = [{class = "Brave";} {class = "firefox";}];
        "4" = [{class = "Spotify";}];
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
          background = surface;
          border = highlightMed;
          childBorder = subtle;
          indicator = subtle;
          text = text;
        };

        focusedInactive = with rosePine; {
          background = base;
          border = highlightLow;
          childBorder = highlightLow;
          indicator = highlightLow;
          text = muted;
        };

        unfocused = with rosePine; {
          background = base;
          border = highlightLow;
          childBorder = highlightLow;
          indicator = highlightLow;
          text = muted;
        };

        urgent = with rosePine; {
          background = love;
          border = love;
          childBorder = love;
          indicator = love;
          text = text;
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
        names = ["Overpass Nerd Font Propo"];
        style = "Medium";
        size = 9.0;
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
        "XF86AudioPlay" = "exec --no-startup-id playerctl play-pause";
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

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        blocks = [
          {
            alert = 10.0;
            block = "disk_space";
            info_type = "available";
            interval = 60;
            path = "/";
            format = "   $available ";
            warning = 20.0;
          }
          {
            block = "memory";
            format = "   $mem_used.eng(w:3) ";
            format_alt = " $icon $swap_used_percents ";
          }
          {
            block = "cpu";
            format = "   $utilization ";
            interval = 1;
          }
          {
            block = "sound";
          }
          {
            block = "time";
            format = " $timestamp.datetime(f:'%b %a %d %R') ";
            interval = 60;
          }
        ];
        settings = {
          theme = {
            theme = "solarized-dark";
            overrides = {
              idle_bg = "#123456";
              idle_fg = "#abcdef";
            };
          };
        };
        icons = "awesome6";
        theme = "gruvbox-dark";
      };
    };
  };
}
