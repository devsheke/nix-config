{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      upgrade = false;
    };

    taps = [ "koekeishiya/formulae" ];

    brews = [
      "yabai"
      "skhd"
    ];

    casks = [
      "aldente"
      "firefox@beta"
      "ghostty"
      "helium-browser"
      "iina"
      "jordanbaird-ice"
      "keepassxc"
      "macs-fan-control"
      "obsidian"
      "onlyoffice"
      "qbittorrent"
      "raycast"
      "tor-browser"
      "zulu@17"
    ];
  };
}
