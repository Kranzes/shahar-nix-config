{
  pkgs,
  lib,
  config,
  ...
}:

{
  users.users.shahar = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
    ]
    ++ lib.optional config.networking.networkmanager.enable "networkmanager"
    ++ lib.optional config.security.tpm2.enable config.security.tpm2.tssGroup;
    shell = pkgs.zsh;
  };

  # Needed to make completion available to home-manager.
  environment.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
}
