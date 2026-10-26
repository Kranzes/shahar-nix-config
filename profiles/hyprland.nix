{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.displayManager.regreet = {
    enable = true;
    font = {
      package = pkgs.roboto;
      name = "Roboto";
    };
  };

  # Used by noctalia's calendar.
  services.gnome.evolution-data-server.enable = true;
}
