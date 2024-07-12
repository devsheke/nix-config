{...}: {
  services.picom = {
    enable = true;
    backend = "glx";
    fade = true;
    fadeDelta = 2;
    fadeSteps = [0.02 0.02];
    opacityRules = ["100:name *= 'Eww - bar'"];
    settings = {
      blur = {
        method = "dual_kawase";
        strength = 2;
      };
      corner-radius = 10;
      focus-exclude = ["name ?= 'Eww - bar'"];
      rounded-corners-exclude = ["name ?= 'Eww - bar'"];
      log-file = "/tmp/picom.log";
    };
    shadow = true;
  };
}
