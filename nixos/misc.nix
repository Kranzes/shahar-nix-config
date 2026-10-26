{ pkgs, ... }:

{
  # Why is Nano even the default???
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  # For mounting USB drives from GUI.
  services.gvfs.enable = true;

  # Packages that should always be available.
  environment.systemPackages = with pkgs; [
    wget
    tree
    htop
    sbctl
  ];

  time.timeZone = "Asia/Jerusalem";
}
