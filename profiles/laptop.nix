{ config, pkgs, ... }:

{
  # For changing display brightness.
  environment.systemPackages = [ pkgs.brightnessctl ];

  # For WiFi.
  networking.networkmanager.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  services = {
    upower.enable = true;
    tuned = {
      enable = true;
      ppdSettings = {
        main.default = "balanced";
        battery = {
          inherit (config.services.tuned.ppdSettings.profiles) power-saver;
        };
      };
    };
    tlp.enable = false;
  };
}
