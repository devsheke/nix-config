{
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
  };

  networking.firewall.allowedTCPPorts = [
    5173
    5174
    5175
    5176
    5177
    5178
  ];
}
