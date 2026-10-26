{
  pkgs,
  lib,
  config,
  ...
}:

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
      init.defaultBranch = "master";
      push.autoSetupRemote = true;
      credential."https://api.github.com".helper = "${pkgs.writeShellScript "gh-api-credential" ''
        ${pkgs.gnused}/bin/sed 's/^host=api\.github\.com$/host=github.com/' | ${lib.getExe config.programs.gh.package} auth git-credential "$@"
      ''}";
    };
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      version = 1;
    };
  };

  home.packages = [ pkgs.git-open ];
}
