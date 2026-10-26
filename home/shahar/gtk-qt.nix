{ pkgs, ... }:

{
  xdg.enable = true;

  home.pointerCursor = {
    enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    colorScheme = "dark";
    font = {
      name = "Roboto";
      size = 10;
      package = pkgs.roboto;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };
}
