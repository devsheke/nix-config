{
  # Despite the option name, this also enables the NVIDIA driver for Wayland.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # The RTX A1000 (Ampere) supports NVIDIA's open kernel modules.
    open = true;
    modesetting.enable = true;
    nvidiaSettings = true;

    # Keep the Wayland session on the Intel iGPU and use NVIDIA on demand.
    prime = {
      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };
}
