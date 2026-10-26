{
  programs.git = {
    enable = true;
    ignores = [
      "*.swp"
      "result"
    ];
    settings = {
      user.name = "Shahar Joselevich";
      user.email = "shahar.joselevich@gmail.com";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings.git_protocol = "ssh";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
