{ config, ... }:

{
  security.sudo.enable = false;

  security.run0 = {
    enable = true;
    sudo-shim.enable = true;
  };

  system.tools.nixos-rebuild.enableRun0Elevation = true;

  # Used by some programs.
  security.pam.services.greetd.enableGnomeKeyring = config.services.greetd.enable;
  services.gnome.gnome-keyring.enable = config.services.greetd.enable;

  security.tpm2.enable = true;
}
