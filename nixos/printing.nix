{
  services.printing.enable = true;

  # Driverless (IPP Everywhere) printer discovery.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
