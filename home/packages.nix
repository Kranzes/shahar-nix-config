{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wget
    nemo
    keepassxc
    yt-dlp
    p7zip
    killall
    libnotify
    wl-clipboard
    grim
    slurp
    calc
    mpv
    imv
    htop
    ranger
    pulsemixer
    tree
    fzf
    gnome-disk-utility
    lm_sensors
    ffmpegthumbnailer
    ffmpeg
    thunderbird-bin
    ookla-speedtest
    nixfmt
    nixpkgs-review
    nix-update
    acpi
    ripgrep
    fd
    sd
    (discord.override {
      withOpenASAR = true;
      withVencord = true;
    })
    signal-desktop
    nixd
  ];
}
