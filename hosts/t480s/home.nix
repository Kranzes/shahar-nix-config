{
  # Overrides.
  home-manager.users.shahar = {
    wayland.windowManager.hyprland.settings.monitor = [
      {
        output = "eDP-1";
        mode = "preferred";
        position = "auto";
        scale = 1;
      }
    ];
  };
}
