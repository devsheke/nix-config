{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = [
      (pkgs.sddm-astronaut.override {
        # Pick the Nord preset
        embeddedTheme = "hyprland_kath"; # hyprland_kath
      })
    ];
  };

  security.polkit.enable = true;
  security.pam.services.sddm.fprintAuth = true;
  security.pam.services.hyprlock.fprintAuth = true;
  security.pam.loginLimits = [
    {
      domain = "sheke";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@libvirtd";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
  ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.libinput.enable = true;
  services.thermald.enable = true;
  services.gvfs.enable = true;
  services.power-profiles-daemon.enable = true;
  services.tumbler.enable = true;
  services.fprintd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.blueman.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
