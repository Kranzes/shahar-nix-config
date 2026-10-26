{ lib, inputs, ... }:

{
  flake.nixosModules = {
    profiles-audio = ./audio.nix;
    profiles-hyprland = ./hyprland.nix;
    profiles-laptop = ./laptop.nix;
    profiles-misc = ./misc.nix;
    profiles-nix-nixpkgs = lib.modules.importApply ./nix-nixpkgs.nix { inherit inputs; };
    profiles-security = ./security.nix;
    profiles-users = ./users.nix;
  };
}
