{...}: {
  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    fadeDelta = 2;
    fadeSteps = [0.02 0.02];
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 2;
      };
      log-file = "/tmp/picom.log";
    };
  };
}
