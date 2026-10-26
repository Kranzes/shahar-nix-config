{ inputs, ... }:

let
  commonProfiles = with inputs.self.nixosModules; [
    profiles-misc
    profiles-nix-nixpkgs
    profiles-security
    profiles-users
  ];

  commonHome = [
    inputs.home-manager.nixosModules.default
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs; };
        users.shahar = import ../home/shahar;
      };
    }
  ];

  nixosSystemWithDefaults =
    {
      hostName,
      modules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./${hostName}
        { networking = { inherit hostName; }; }
      ]
      ++ commonProfiles
      ++ modules;
    };
in

{
  flake.nixosConfigurations = {
    t480s = nixosSystemWithDefaults {
      hostName = "t480s";
      modules = commonHome;
    };
  };
}
