{pkgs, ...}: let
  notosansFont = "Noto Sans";
  geistmonoFont = "GeistMono Nerd Font Propo";
  nixBlue = "#7ebae4";
  rosePine = (import ../../../modules/rose-pine.nix {}).main;
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
        {class = "gsimplecal";}
      ];
      fonts = {
        names = [notosansFont];
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
        {command = "nm-applet";}
        {command = "blueman-applet";}
        {command = "keepassxc";}
        {command = "alacritty";}
        {command = "firefox-beta";}
      ];
    };
  };

  services.polybar = rec {
    enable = true;
    package = pkgs.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };
    script = ''
      polybar --reload bar-1 -c ~/.config/polybar/config.ini &
      polybar --reload bar-2 -c ~/.config/polybar/config.ini &
    '';
    config = with rosePine; {
      "bar/bar-1" = {
        monitor = "HDMI-0";
        background = base;
        font-0 = "Noto Sans:size=9:weight=SemiBold;2";
        font-1 = "Font Awesome 6 Free Solid:size=9:style=Solid;2";
        font-2 = "${geistmonoFont}:size=12;3";
        foreground = text;
        height = "25px";
        line-size = "2pt";
        modules-center = "date";
        modules-left = "powermenu i3";
        modules-right = "pulseaudio temperature cpu memory filesystem tray-spacer tray";
        radius = 0;
        width = "100%";
      };

      "bar/bar-2" =
        config."bar/bar-1"
        // {
          monitor = "VGA-0";
          modules-right = "pulseaudio temperature cpu memory filesystem";
        };

      "module/powermenu" = let
        confirm = "%{F${foam}}%{F-} Confirm";
        cancel = "%{F${rose}}%{F-} Cancel";
      in {
        type = "custom/menu";
        expand-right = true;
        label-separator = "%{F${base}}|%{F-}";
        label-separator-padding = 2;
        menu-0-0 = "%{F${pine}}%{F-} Logout";
        menu-0-0-exec = "#powermenu.open.1";
        menu-1-0 = cancel;
        menu-1-1 = confirm;
        menu-1-1-exec = "${pkgs.i3}/bin/i3-msg exit";
        menu-0-1 = "%{F${gold}}%{F-} Lock";
        menu-0-1-exec = "#powermenu.open.2";
        menu-2-0 = cancel;
        menu-2-1 = confirm;
        menu-2-1-exec = "${pkgs.lightdm}/bin/dm-tool lock";
        menu-0-2 = "%{F${iris}}%{F-} Reboot";
        menu-0-2-exec = "#powermenu.open.3";
        menu-3-0 = cancel;
        menu-3-1 = confirm;
        menu-3-1-exec = "${pkgs.systemd}/bin/systemctl reboot";
        menu-0-3 = "%{F${rose}}%{F-} Poweroff";
        menu-0-3-exec = "#powermenu.open.4";
        menu-4-0 = cancel;
        menu-4-1 = confirm;
        menu-4-1-exec = "${pkgs.systemd}/bin/systemctl poweroff";
        label-open = "%{F${nixBlue}}%{T3}%{T-}%{F-}";
        label-open-padding-left = 4;
        label-close = "%{F${nixBlue}}%{T3}%{T-}%{F-}";
        label-close-padding-left = 4;
      };

      "module/date" = {
        type = "custom/script";
        interval = 5;
        exec = "${pkgs.coreutils}/bin/coreutils --coreutils-prog=date '+%a %b %d %H:%M'";
        click-left = "${pkgs.gsimplecal}/bin/gsimplecal &";
      };

      "module/i3" = {
        type = "internal/i3";
        format-margin = 4;
        format = "<label-state> <label-mode>";
        index-sort = "true";
        label-focused = "%index%";
        label-unfocused = "%index%";
        label-urgent = "%index%";
        label-visible = "%index%";
        label-focused-background = highlightMed;
        label-focused-underline = pine;
        label-focused-padding-right = 2;
        label-focused-padding-left = 2;
        label-unfocused-padding-right = 2;
        label-unfocused-padding-left = 2;
        label-urgent-padding-right = 2;
        label-urgent-padding-left = 2;
        label-visible-padding-right = 2;
        label-visible-padding-left = 2;
        show-urget = true;
      };

      "module/temperature" = {
        type = "internal/temperature";
        ramp-0 = "%{F${pine}}%{F-}";
        ramp-1 = "%{F${pine}}%{F-}";
        ramp-2 = "%{F${rose}}%{F-}";
        zone-type = "x86_pkg_temp";
        format = "<ramp> <label>";
        format-background = overlay;
        ramp-padding-left = 5;
        label-padding-right = 2;
      };

      "module/cpu" = {
        type = "internal/cpu";
        label = "%{F${gold}}%{F-} %percentage%%";
        label-padding-left = 2;
        label-padding-right = 2;
        format-background = overlay;
      };

      "module/memory" = {
        type = "internal/memory";
        label = "%{F${love}}%{F-} %gb_used%";
        label-padding-left = 2;
        label-padding-right = 2;
        format-background = overlay;
      };

      "module/filesystem" = {
        type = "internal/fs";
        mount-0 = "/";
        interval = 10;
        label-mounted = "%{F${iris}}%{F-} %free%";
        label-mounted-padding-left = 2;
        label-mounted-padding-right = 4;
        format-mounted-background = overlay;
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        click-right = "pavucontrol";
        ramp-volume-0 = "%{F${muted}}%{T1} %{T-}%{F-}";
        ramp-volume-1 = "%{F${foam}}%{T1} %{T-}%{F-}";
        ramp-volume-2 = "%{F${foam}}%{T1} %{T-}%{F-}";
        label-muted = "%{F${rose}}%{T1}%{T-}%{F-}";
        format-volume = "<ramp-volume> <label-volume>";
        label-volume-padding-right = 4;
      };

      "module/tray" = {
        type = "internal/tray";
        tray-spacing = "8px";
        format = "<tray>   ";
      };
    };

    extraConfig = with rosePine; ''
      [module/tray-spacer]
      type = custom/text
      label-foreground = ${base}
      label = "|"
      label-padding-left = 3
    '';
  };
}
