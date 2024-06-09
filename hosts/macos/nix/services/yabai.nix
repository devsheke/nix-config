{pkgs, ...}: {
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "on";
      window_origin_display = "focused";
      window_opacity_duration = 0.0;
      window_shadow = "off";
      window_placement = "second_child";

      top_padding = 15;
      bottom_padding = 15;
      left_padding = 15;
      right_padding = 15;
      window_gap = 15;
    };
    extraConfig = ''
      # Custom spaces for 3 desktops
      yabai -m space 1 --label one
      yabai -m space 2 --label two
      yabai -m space 3 --label three
      yabai -m space 4 --label four
      yabai -m space 5 --label five
      yabai -m space 6 --label six
      yabai -m space 7 --label seven
      yabai -m space 8 --label eight
      yabai -m space 9 --label nine
      yabai -m space 10 --label ten

      # Float system preferences. Most of these just diable Yabai from resizing them.
      yabai -m rule --add app="^Brave" manage=on sticky=off space=^2
      yabai -m rule --add app="^Alacritty" manage=on sticky=off space=^1
      yabai -m rule --add app="^System Preferences$" sticky=off manage=off
      yabai -m rule --add app="^Finder$" sticky=off manage=off
      yabai -m rule --add app="^Disk Utility$" sticky=off manage=off
      yabai -m rule --add app="^System Information$" sticky=off manage=off
      yabai -m rule --add app="^Activity Monitor$" sticky=off manage=off
      yabai -m rule --add title="^Spotify$" sticky=off manage=off space=^3
      yabai -m rule --add app="^Music$" sticky=off manage=off
      yabai -m rule --add app="^Messages$" sticky=off manage=off
      yabai -m rule --add app="^App Store$" sticky=off manage=off
      yabai -m rule --add app="^balenaEtcher$" sticky=off manage=off
      yabai -m rule --add app="^Preview$" sticky=off manage=off
      yabai -m rule --add app="^QuickTimePlayer$" sticky=off manage=off
      yabai -m rule --add title="^Signal$" sticky=off manage=off space=^4
      yabai -m rule --add app="^IINA$" sticky=off manage=off space=^5
      yabai -m rule --add app="^qBittorrent$" sticky=off manage=off space=^6
    '';
  };
}
