{ lib, ... }: {
  services.avahi = {
    enable = true;
    nssmdns4 = true;

    ipv4 = true;
    ipv6 = false;

    openFirewall = true;

    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };

    allowInterfaces = [ "wlp0s20f3" ];
  };

  networking.hosts."127.0.0.1" = [
    "sanguinius.local"
  ];

  # Make the static mapping take precedence over mDNS.
  system.nssDatabases.hosts = lib.mkForce [
    "files"
    "mymachines"
    "myhostname"
    "mdns4_minimal [NOTFOUND=return]"
    "dns"
  ];

  networking.firewall.allowedTCPPorts = [
    5432
    5173
    5174
    5175
    5176
    5177
    5178
    9000
    9001
  ];
}
