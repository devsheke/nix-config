{ pkgs, ... }:
{
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
      yabai -m space 8 --label eight
      yabai -m space 9 --label nine
      yabai -m space 10 --label ten

      # floating
      yabai -m rule --add app="^‎WhatsApp" manage=off sticky=off
      yabai -m rule --add app="^Activity Monitor$" sticky=off manage=off
      yabai -m rule --add app="^App Store$" sticky=off manage=off
      yabai -m rule --add app="^balenaEtcher$" sticky=off manage=off
      yabai -m rule --add app="^Disk Utility$" sticky=off manage=off
      yabai -m rule --add app="^Finder$" sticky=off manage=off
      yabai -m rule --add app="^KeePassXC$" sticky=off manage=off
      yabai -m rule --add app="^Preview$" sticky=off manage=off
      yabai -m rule --add app="^System Information$" sticky=off manage=off
      yabai -m rule --add app="^System Settings$" sticky=off manage=off
      yabai -m rule --add app="^Messages$" sticky=off manage=off
      yabai -m rule --add app="^SteelSeries GG$" sticky=off manage=off
      yabai -m rule --add app="^qBittorrent$" sticky=off manage=off
      yabai -m rule --add app="^Music$" sticky=off manage=off
      yabai -m rule --add app="^Spotify$" sticky=off manage=off
      yabai -m rule --add app="^Discord$" sticky=off manage=off
      yabai -m rule --add app="^Find My$" sticky=off manage=off

      yabai -m rule --add app="^Ghostty$" manage=on sticky=off space=^1

      yabai -m rule --add app="^Chromium$" space=^2
      yabai -m rule --add app="^Zen$" space=^2
      yabai -m rule --add app="^Safari$" space=^2

      yabai -m rule --add app="^Adobe (\w)*$" space=^3
      yabai -m rule --add app="^Figma$" space=^3
      yabai -m rule --add app="^Creative Cloud$" sticky=off manage=off space=^3

      yabai -m rule --add app="^Obsidian$" sticky=off manage=off space=^4
      yabai -m rule --add app="^Yomu$" sticky=off manage=off

      yabai -m rule --add app="^IINA$" sticky=off manage=off space=^5
      yabai -m rule --add app="^Photo Booth$" sticky=off manage=off space=^5
      yabai -m rule --add app="^QuickTime Player$" sticky=off manage=off space=^5
      yabai -m rule --add app="^TV$" sticky=off manage=off

      yabai -m rule --add app="^CrossOver$" sticky=off manage=off space=^6
      yabai -m rule --add app="^Steam$" sticky=off manage=off space=^6
      yabai -m rule --add app="^(\w).*\.exe$" sticky=off manage=off space=^6

      yabai -m rule --add app="^Docker" manage=off sticky=off space=^7
    '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      alt + shift - r : yabai --restart-service

      alt + shift - 0x2F : yabai -m space --move next
      alt + shift - 0x2B : yabai -m space --move prev

      alt - 1 : yabai -m space --focus 1
      alt - 2 : yabai -m space --focus 2
      alt - 3 : yabai -m space --focus 3
      alt - 4 : yabai -m space --focus 4
      alt - 5 : yabai -m space --focus 5
      alt - 6 : yabai -m space --focus 6
      alt - 7 : yabai -m space --focus 7
      alt - 8 : yabai -m space --focus 8
      alt - 9 : yabai -m space --focus 9
      alt - 0 : yabai -m space --focus 10

      alt - 0x2F : yabai -m space --focus next
      alt - 0x2B : yabai -m space --focus prev

      alt - h : yabai -m window --focus west
      alt - j : yabai -m window --focus south
      alt - k : yabai -m window --focus north
      alt - l : yabai -m window --focus east

      shift + alt - k : yabai -m window --swap north
      shift + alt - h : yabai -m window --swap west
      shift + alt - j : yabai -m window --swap south
      shift + alt - l : yabai -m window --swap east

      alt + shift - 1 : yabai -m window --space 1
      alt + shift - 2 : yabai -m window --space 2
      alt + shift - 3 : yabai -m window --space 3
      alt + shift - 4 : yabai -m window --space 4
      alt + shift - 5 : yabai -m window --space 5
      alt + shift - 6 : yabai -m window --space 6
      alt + shift - 7 : yabai -m window --space 7
      alt + shift - 8 : yabai -m window --space 8
      alt + shift - 9 : yabai -m window --space 9
      alt + shift - 0 : yabai -m window --space 10

      alt + shift - f : yabai -m window --toggle float
    '';
  };

}
