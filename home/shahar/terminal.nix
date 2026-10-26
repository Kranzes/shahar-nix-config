{
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      font-family = "JetBrainsMono Nerd Font";
      font-size = 10;
      window-padding-x = 3;
      window-padding-y = 3;
      confirm-close-surface = false;
      shell-integration-features = "ssh-env,ssh-terminfo";
      # Lets claude-code insert newlines.
      keybind = [ "shift+enter=text:\\n" ];
    };
  };
}
