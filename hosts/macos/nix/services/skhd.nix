{pkgs, ...}: {
  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      rcmd + rshift - n : yabai -m space --create
      rcmd + lcmd + rshift - d : yabai -m space --destroy

      rcmd + rshift - 0x2F : yabai -m space --move next
      rcmd + rshift - 0x2B : yabai -m space --move prev

      rcmd - 1 : yabai -m space --focus 1
      rcmd - 2 : yabai -m space --focus 2
      rcmd - 3 : yabai -m space --focus 3
      rcmd - 4 : yabai -m space --focus 4
      rcmd - 5 : yabai -m space --focus 5
      rcmd - 6 : yabai -m space --focus 6
      rcmd - 7 : yabai -m space --focus 7
      rcmd - 8 : yabai -m space --focus 8
      rcmd - 9 : yabai -m space --focus 9
      rcmd - 0 : yabai -m space --focus 10

      rcmd - 0x2F : yabai -m space --focus next
      rcmd - 0x2B : yabai -m space --focus prev

      rcmd - w : yabai -m window --focus north
      rcmd - a : yabai -m window --focus west
      rcmd - s : yabai -m window --focus south
      rcmd - d : yabai -m window --focus east

      rshift + rcmd - w : yabai -m window --swap north
      rshift + rcmd - a : yabai -m window --swap west
      rshift + rcmd - s : yabai -m window --swap south
      rshift + rcmd - d : yabai -m window --swap east

      rcmd + rshift - 1 : yabai -m window --space 1
      rcmd + rshift - 2 : yabai -m window --space 2
      rcmd + rshift - 3 : yabai -m window --space 3
      rcmd + rshift - 4 : yabai -m window --space 4
      rcmd + rshift - 5 : yabai -m window --space 5
      rcmd + rshift - 6 : yabai -m window --space 6
      rcmd + rshift - 7 : yabai -m window --space 7
      rcmd + rshift - 8 : yabai -m window --space 8
      rcmd + rshift - 9 : yabai -m window --space 9
      rcmd + rshift - 0 : yabai -m window --space 10

      rcmd - f : yabai -m window --toggle float

      rshift + ralt - r : yabai -m space --rotate 90

      ralt + rshift - b : alacritty -T Btop -e btop
    '';
  };
}
