{...}: {
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
    };
    casks = [
      "aldente"
      "docker-desktop"
      "ghostty"
      "figma"
      "iina"
      "jordanbaird-ice"
      "keepassxc"
      "linearmouse"
      "macs-fan-control"
      "onlyoffice"
      "qbittorrent"
      "spotify"
      "raycast"
      "tor-browser"
      "ungoogled-chromium"
      "whatsapp"
      "zen-browser"
    ];
  };
}
