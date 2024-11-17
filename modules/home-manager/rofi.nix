{
  config,
  pkgs,
  ...
}: {
  programs.rofi = {
    enable = true;
    plugins = [pkgs.rofi-calc pkgs.rofi-emoji];
    terminal = "${pkgs.alacritty}/bin/alacritty";
    font = "Noto Sans 12";
    extraConfig = {
      modes = "window,drun,ssh,calc,emoji";
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral "#faf4ed";
        cur = mkLiteral "#fffaf3";
        fgd = mkLiteral "#575279";
        cmt = mkLiteral "#9893a5";
        cya = mkLiteral "#56949f";
        grn = mkLiteral "#286983";
        ora = mkLiteral "#d7827e";
        pur = mkLiteral "#907aa9";
        red = mkLiteral "#b4637a";
        yel = mkLiteral "#ea9d34";
        font = "Noto Sans 12";
        foreground = mkLiteral "@fgd";
        background = mkLiteral "@bg";
        active-background = mkLiteral "@grn";
        urgent-background = mkLiteral "@red";
        selected-background = mkLiteral "@active-background";
        selected-urgent-background = mkLiteral "@urgent-background";
        selected-active-background = mkLiteral "@active-background";
        separatorcolor = mkLiteral "@active-background";
        bordercolor = mkLiteral "@ora";
      };

      "#window" = {
        background-color = mkLiteral "@background";
        border = 3;
        border-radius = 6;
        border-color = mkLiteral "@bordercolor";
        padding = 5;
      };
      "#mainbox" = {
        border = 0;
        padding = 5;
      };
      "#message" = {
        border = mkLiteral "1px dash 0px 0px";
        border-color = mkLiteral "@separatorcolor";
        padding = mkLiteral "1px";
      };
      "#textbox" = {
        text-color = mkLiteral "@foreground";
      };

      "#listview" = {
        fixed-height = 0;
        border = mkLiteral "2px dash 0px 0px";
        border-color = mkLiteral "@bordercolor";
        spacing = mkLiteral "2px";
        scrollbar = false;
        padding = mkLiteral "2px 0px 0px";
      };
      "#element" = {
        border = 0;
        padding = mkLiteral "1px";
      };
      "#element.normal.normal" = {
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
      };
      "#element.normal.urgent" = {
        background-color = mkLiteral "@urgent-background";
        text-color = mkLiteral "@foreground";
      };
      "#element.normal.active" = {
        background-color = mkLiteral "@active-background";
        text-color = mkLiteral "@background";
      };
      "#element.selected.normal" = {
        background-color = mkLiteral "@selected-background";
        text-color = mkLiteral "@foreground";
      };
      "#element.selected.urgent" = {
        background-color = mkLiteral "@selected-urgent-background";
        text-color = mkLiteral "@foreground";
      };
      "#element.selected.active" = {
        background-color = mkLiteral "@selected-active-background";
        text-color = mkLiteral "@background";
      };
      "#element.alternate.normal" = {
        background-color = mkLiteral "@background";
        text-color = mkLiteral "@foreground";
      };
      "#element.alternate.urgent" = {
        background-color = mkLiteral "@urgent-background";
        text-color = mkLiteral "@foreground";
      };
      "#element.alternate.active" = {
        background-color = mkLiteral "@active-background";
        text-color = mkLiteral "@foreground";
      };
      "#scrollbar" = {
        width = mkLiteral "2px";
        border = 0;
        handle-width = mkLiteral "8px";
        padding = 0;
      };
      "#sidebar" = {
        border = mkLiteral "2 px dash 0 px 0 px";
        border-color = mkLiteral "@separatorcolor";
      };
      "#button.selected" = {
        background-color = mkLiteral "@selected-background";
        text-color = mkLiteral "@foreground";
      };
      "#inputbar" = {
        spacing = 0;
        text-color = mkLiteral "@foreground";
        padding = mkLiteral "1px";
      };
      "#case-indicator" = {
        spacing = 0;
        text-color = mkLiteral "@foreground";
      };
      "#entry" = {
        spacing = 0;
        text-color = mkLiteral "@cya";
      };
      "#prompt" = {
        spacing = 0;
        text-color = mkLiteral "@grn";
      };
      "#inputbar" = {
        children = map mkLiteral [
          "prompt"
          "textbox-prompt-colon"
          "case-indicator"
        ];
      };
      "#textbox-prompt-colon" = {
        expand = false;
        str = ":";
        margin = mkLiteral "0px 0.3em 0em 0em";
        text-color = mkLiteral "@grn";
      };
    };
  };
}
