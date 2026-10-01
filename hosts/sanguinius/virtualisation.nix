{
  config,
  pkgs,
  ...
}:
{
  boot.extraModulePackages = [ config.boot.kernelPackages.kvmfr ];

  boot.blacklistedKernelModules = [
    "nouveau"
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
  ];

  boot.kernelModules = [
    "kvmfr"
    "vfio_pci"
  ];

  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=64
  '';

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = [ "sheke" ];
  users.users.qemu-libvirtd.extraGroups = [ "input" ];

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
      vhostUserPackages = [ pkgs.virtiofsd ];
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      dns = [
        "1.1.1.1"
        "8.8.8.8"
      ];
    };

    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };
}
