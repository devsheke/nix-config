{
  config,
  pkgs,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
  rosePine = (import ../rose-pine.nix {}).main;
in {
  programs.rofi = {
    enable = true;
    plugins = [pkgs.rofi-calc pkgs.rofi-emoji];
    terminal = "${pkgs.alacritty}/bin/alacritty";
    font = "Overpass Nerd Font Propo 12";
    extraConfig = {
      modi = "window,drun,ssh,calc,emoji";
      cycle = true;
      filter = "";
      steal-focus = false;
      matching = "normal";
      tokenize = true;
      icon-theme = "${pkgs.rose-pine-icon-theme}";
      ssh-client = "ssh";
      ssh-command = "{terminal} -e {ssh-client} {host} [-p {port}]";
      parse-hosts = true;
      parse-known-hosts = true;
      drun-categories = "";
      drun-match-fields = "name,generic,exec,categories,keywords";
      drun-show-actions = false;
      drun-url-launcher = "xdg-open";
      drun-use-desktop-cache = false;
      drun-reload-desktop-cache = false;
      # "drun" = {
      #   parse-user = true;
      #   parse-system = true;
      # };
      run-command = "{cmd}";
      run-list-command = "";
      run-shell-command = "{terminal} -e {cmd}";
      # "drun,run" = {
      #   fallback-icon = "application-x-addon";
      # };
      window-match-fields = "title,class,role,name,desktop";
      window-command = "wmctrl -i -R {window}";
      window-thumbnail = false;
      disable-history = false;
      sorting-method = "normal";
      max-history-size = 25;
      display-emoji = "";
      display-ssh = "";
      sort = false;
      threads = 0;
      click-to-exit = true;
      show-icons = true;
      display-drun = "";
      display-calc = "";
      display-run = "";
      display-filebrowser = "";
      display-window = "";
      drun-display-format = "{name}";
      window-format = "{w} · {c} · {t}";
      # filebrowser = {
      #   directories-first = true;
      #   sorting-method = "name";
      # };
      # timeout = {
      #   action = "kb-cancel";
      #   delay = 0;
      # };
    };
    theme = {
      "*" = with rosePine; {
        border-colour = mkLiteral highlightMed;
        handle-colour = mkLiteral highlightMed;
        background-colour = mkLiteral base;
        foreground-colour = mkLiteral text;
        alternate-background = mkLiteral surface;
        normal-background = mkLiteral base;
        normal-foreground = mkLiteral text;
        urgent-background = mkLiteral rose;
        urgent-foreground = mkLiteral base;
        active-background = mkLiteral pine;
        active-foreground = mkLiteral base;
        selected-normal-background = mkLiteral highlightMed;
        selected-normal-foreground = mkLiteral text;
        selected-urgent-background = mkLiteral pine;
        selected-urgent-foreground = mkLiteral base;
        selected-active-background = mkLiteral rose;
        selected-active-foreground = mkLiteral base;
        alternate-normal-background = mkLiteral base;
        alternate-normal-foreground = mkLiteral text;
        alternate-urgent-background = mkLiteral rose;
        alternate-urgent-foreground = mkLiteral text;
        alternate-active-background = mkLiteral pine;
        alternate-active-foreground = mkLiteral base;
      };
      window = {
        transparency = "real";
        location = mkLiteral "center";
        anchor = mkLiteral "center";
        fullscreen = false;
        width = mkLiteral "600px";
        x-offset = mkLiteral "0px";
        y-offset = mkLiteral "0px";
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        cursor = "default";
      };
      mainbox = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "30px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        children = map mkLiteral ["inputbar" "message" "listview"];
      };
      inputbar = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        children = map mkLiteral ["textbox-prompt-colon" "entry" "mode-switcher"];
      };
      prompt = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      textbox-prompt-colon = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        expand = false;
        str = "";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      entry = {
        enabled = true;
        padding = mkLiteral "5px 0px";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "text";
        placeholder = "Search...";
        placeholder-color = mkLiteral "inherit";
      };
      num-filtered-rows = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      textbox-num-sep = {
        enabled = true;
        expand = false;
        str = "/";
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      num-rows = {
        enabled = true;
        expand = false;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      case-indicator = {
        enabled = true;
        background-color = mkLiteral "inherit";
        text-color = mkLiteral "inherit";
      };
      listview = {
        enabled = true;
        columns = 1;
        lines = 8;
        cycle = true;
        dynamic = true;
        scrollbar = true;
        layout = mkLiteral "vertical";
        reverse = false;
        fixed-height = true;
        fixed-columns = true;

        spacing = mkLiteral "5px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = "default";
      };
      scrollbar = {
        handle-width = mkLiteral "5px ";
        handle-color = mkLiteral "@handle-colour";
        border-radius = mkLiteral "10px";
        background-color = mkLiteral "@alternate-background";
      };
      element = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "5px 10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
        cursor = mkLiteral "pointer";
      };
      "element normal.normal" = {
        background-color = mkLiteral "var(normal-background)";
        text-color = mkLiteral "var(normal-foreground)";
      };
      "element normal.urgent" = {
        background-color = mkLiteral "var(urgent-background)";
        text-color = mkLiteral "var(urgent-foreground)";
      };
      "element normal.active" = {
        background-color = mkLiteral "var(active-background)";
        text-color = mkLiteral "var(active-foreground)";
      };
      "element selected.normal" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      "element selected.urgent" = {
        background-color = mkLiteral "var(selected-urgent-background)";
        text-color = mkLiteral "var(selected-urgent-foreground)";
      };
      "element selected.active" = {
        background-color = mkLiteral "var(selected-active-background)";
        text-color = mkLiteral "var(selected-active-foreground)";
      };
      "element alternate.normal" = {
        background-color = mkLiteral "var(alternate-normal-background)";
        text-color = mkLiteral "var(alternate-normal-foreground)";
      };
      "element alternate.urgent" = {
        background-color = mkLiteral "var(alternate-urgent-background)";
        text-color = mkLiteral "var(alternate-urgent-foreground)";
      };
      "element alternate.active" = {
        background-color = mkLiteral "var(alternate-active-background)";
        text-color = mkLiteral "var(alternate-active-foreground)";
      };
      element-icon = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        size = mkLiteral "24px";
        cursor = mkLiteral "inherit";
      };
      element-text = {
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "inherit";
        highlight = mkLiteral "inherit";
        cursor = mkLiteral "inherit";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
      };
      mode-switcher = {
        enabled = true;
        spacing = mkLiteral "10px";
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };
      button = {
        padding = mkLiteral "5px 10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "inherit";
        cursor = mkLiteral "pointer";
      };
      "button selected" = {
        background-color = mkLiteral "var(selected-normal-background)";
        text-color = mkLiteral "var(selected-normal-foreground)";
      };
      message = {
        enabled = true;
        margin = mkLiteral "0px";
        padding = mkLiteral "0px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "0px 0px 0px 0px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "transparent";
        text-color = mkLiteral "@foreground-colour";
      };
      textbox = {
        padding = mkLiteral "8px 10px";
        border = mkLiteral "0px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@alternate-background";
        text-color = mkLiteral "@foreground-colour";
        vertical-align = mkLiteral "0.5";
        horizontal-align = mkLiteral "0.0";
        highlight = mkLiteral "none";
        placeholder-color = mkLiteral "@foreground-colour";
        blink = true;
        markup = true;
      };
      error-message = {
        padding = mkLiteral "10px";
        border = mkLiteral "2px solid";
        border-radius = mkLiteral "10px";
        border-color = mkLiteral "@border-colour";
        background-color = mkLiteral "@background-colour";
        text-color = mkLiteral "@foreground-colour";
      };
    };
  };
}
