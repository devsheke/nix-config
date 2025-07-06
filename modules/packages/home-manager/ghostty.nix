{...}: {
  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      background-blur = true;
      background-opacity = "0.8";
      cursor-style = "block";
      cursor-style-blink = false;
      font-synthetic-style = true;
      font-thicken = true;
      shell-integration-features = "no-cursor";
      theme = "rose-pine";
    };
  };
}
