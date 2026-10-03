{
  config,
  lib,
  pkgs,
  ...
}: let
  sddmTheme = pkgs.callPackage ./sddm-rose-pine.nix {
    wallpaper = config.stylix.image;
  };
in {
  # Install the same customized theme used by the greeter's Qt environment.
  environment.systemPackages = [sddmTheme];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "rose-pine-glass";
    extraPackages = [sddmTheme];
  };

  security.polkit.enable = true;
  security.pam.services = {
    sddm = {
      fprintAuth = false;
      # SDDM delegates authentication to login, which still allows fingerprints
      # for the console. Redirect only its auth stack to a password-only service.
      rules.auth.login.modulePath = lib.mkForce "sddm-password";
    };
    sddm-password = {
      fprintAuth = false;
      enableGnomeKeyring = config.services.gnome.gnome-keyring.enable;
    };
    # Hyprlock's native fingerprint backend scans in parallel with password PAM.
    # Avoid a second fingerprint reader claim when a password is submitted.
    hyprlock.fprintAuth = false;
  };
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
  services.upower.enable = true;
  services.tumbler.enable = true;
  # Enables fingerprint PAM authentication by default (sudo, polkit, login, etc.).
  services.fprintd.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.blueman.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = ["graphical-session.target"];
    wants = ["graphical-session.target"];
    after = ["graphical-session.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.udev = {
    packages = with pkgs; [platformio-core.udev];
    extraRules = ''
      SUBSYSTEM=="drm", KERNEL=="card[0-9]*", KERNELS=="0000:00:02.0", DRIVERS=="i915", SYMLINK+="dri/intel-igpu"
    '';
  };
}
