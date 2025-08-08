{ ... }:
{
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
      "macs-fan-control"
      "music-presence"
      "obsidian"
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
