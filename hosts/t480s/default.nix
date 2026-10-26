{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./home.nix
  ]
  ++ (with inputs.self.nixosModules; [
    profiles-audio
    profiles-laptop
    profiles-hyprland
  ]);

  system.stateVersion = "26.11";
}
