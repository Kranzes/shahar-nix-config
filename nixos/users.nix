{ pkgs, config, ... }:

{
  users.users.shahar = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
      config.security.tpm2.tssGroup
    ];
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableGlobalCompInit = false;
  };
}
