{pkgs, ...}: {
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      layout = "bsp";

      top_padding = 6;
      bottom_padding = 6;
      left_padding = 6;
      right_padding = 6;
      window_gap = 6;

      mouse_follows_focus = "on";

      window_placement = "second_child";
    };
    extraConfig = ''
      yabai -m space 1 --label one
      yabai -m space 2 --label two
      yabai -m space 3 --label three
      yabai -m space 4 --label four
      yabai -m space 5 --label five
      yabai -m space 6 --label six
      yabai -m space 7 --label seven
      yabai -m space 6 --label eight
      yabai -m space 9 --label nine
      yabai -m space 10 --label ten

      yabai -m rule --add app="^Alacritty" manage=on sticky=off space=^1
      yabai -m rule --add app="^System Settings$" sticky=off manage=off
      yabai -m rule --add app="^Finder$" sticky=off manage=off
      yabai -m rule --add app="^Disk Utility$" sticky=off manage=off
      yabai -m rule --add app="^System Information$" sticky=off manage=off
      yabai -m rule --add app="^Activity Monitor$" sticky=off manage=off
      yabai -m rule --add app="^Photo Booth$" sticky=off manage=off space=^5
      yabai -m rule --add app="^Spotify$" sticky=off manage=off space=^5
      yabai -m rule --add app="^Music$" sticky=off manage=off
      yabai -m rule --add app="^Messages$" sticky=off manage=off
      yabai -m rule --add app="^App Store$" sticky=off manage=off
      yabai -m rule --add app="^balenaEtcher$" sticky=off manage=off
      yabai -m rule --add app="^Preview$" sticky=off manage=off
      yabai -m rule --add app="^QuickTime Player$" sticky=off manage=off
      yabai -m rule --add app="^Signal$" sticky=off manage=off space=^4
      yabai -m rule --add app="^IINA$" sticky=off manage=off space=^5
      yabai -m rule --add app="^qBittorrent$" sticky=off manage=off space=^6
      yabai -m rule --add app="^KeePassXC" sticky=off manage=off
      yabai -m rule --add app="^Zen Browser$" space=^2
    '';
  };
}
