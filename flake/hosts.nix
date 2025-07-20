{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      lib = import ../lib {
        nix = inputs.nixpkgs;
        home = inputs.home-manager;
      };
      specialArgs = {
        system = "x86_64-linux";
        atomazu = {
          inherit inputs;
          inherit lib;
        };
      };
    in
    {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ../modules/nixos
          ../hosts/desktop
        ];
      };

      server = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ../modules/nixos
          ../hosts/server
        ];
      };
    };
}
