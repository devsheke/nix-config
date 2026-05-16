{
  config,
  lib,
  pkgs,
  ...
}:
{
  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];

  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidia"
    "nvidia_drm"
    "nvidia_modeset"
    "nvidia_uvm"
  ];

  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot.kernelParams = [
    "kvmfr.static_size_mb=64"
    "intel_iommu=on"
    "iommu=pt"
    "video=efifb:off"
    "video=vesafb:off"
    "video=simplefb:off"
  ];

  boot.kernelModules = [ "kvmfr" ];

  boot.extraModprobeConfig = ''
    options vfio-pci ids=10de:25b9,10de:2291
    options kvmfr static_size_mb=64
  '';

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "sheke" ];

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", OWNER="sheke", GROUP="kvm", MODE="0660"
  '';

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      swtpm.enable = true;
      verbatimConfig = ''
        namespaces = []
        cgroup_device_acl = [
          "/dev/null", 
          "/dev/full", 
          "/dev/zero",
          "/dev/random", 
          "/dev/urandom",
          "/dev/ptmx", 
          "/dev/kvm", 
          "/dev/kqemu",
          "/dev/rtc",
          "/dev/hpet", 
          "/dev/vfio/vfio",
          "/dev/kvmfr0"
        ]
      '';
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
}
