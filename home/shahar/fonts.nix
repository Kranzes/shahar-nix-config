{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    roboto
    noto-fonts
    noto-fonts-color-emoji
  ];
}
