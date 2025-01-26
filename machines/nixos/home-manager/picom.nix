{...}: let
  excludeList = [
    "window_type = 'dock'"
    "window_type = 'desktop'"
    "window_type = 'utility'"
    "window_type = 'dialog'"
    "window_type = 'popup_menu'"
    "window_type = 'menu'"
    "window_type = 'dropdown_menu'"
    "window_type = 'tooltip'"
    "window_type = 'splash'"
    "_GTK_FRAME_EXTENTS@:c"
  ];
in {
  services.picom = {
    enable = true;
    backend = "glx";
    shadowExclude = excludeList;
    settings = {
      blur-background-exclude = excludeList;
    };
  };
}
