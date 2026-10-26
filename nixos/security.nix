{
  security.sudo.enable = false;

  security.run0 = {
    enable = true;
    sudo-shim.enable = true;
    persistentAuth.enable = true;
  };

  # Cache auth for 30s
  security.polkit.settings.Polkitd.ExpirationSeconds = 30;

  system.tools.nixos-rebuild.enableRun0Elevation = true;

  # Used by some programs.
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  services.gnome.gcr-ssh-agent.enable = false;

  services.pcscd.enable = true;

  security.tpm2.enable = true;
}
