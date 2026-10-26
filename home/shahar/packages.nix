{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nautilus
    firefox
    libnotify
    wl-clipboard
    mpv
    imv
    ripgrep
    fd
    jq
    nixd
    nixfmt
    nixpkgs-review
  ];
}
