{ pkgs, ... }:

{
  services = {
    gnome-keyring = {
      enable = true;
      components = [ "secrets" ];
    };
    gpg-agent = {
      enable = true;
      enableScDaemon = false;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };
}
