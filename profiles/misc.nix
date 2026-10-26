{
  config,
  pkgs,
  ...
}:

{
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # For mounting USB drives from GUI.
  services.gvfs.enable = config.services.graphical-desktop.enable;

  # Packages that should always be available.
  environment.systemPackages = with pkgs; [
    wget
    gitMinimal
    tree
    htop
    sbctl
  ];

  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_US.UTF-8";
}
