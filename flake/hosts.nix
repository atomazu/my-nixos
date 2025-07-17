{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      lib = import ../lib { lib = inputs.nixpkgs.lib; };
      specialArgs = {
        system = "x86_64-linux";
        atomazu = {
          inputs = {
            inherit (inputs)
              quickshell
              nixvim
              sops-nix
              home-manager
              stylix
              ashell
              firefox-addons
              ;
          };
          inherit lib;
        };
      };
    in
    {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ../hosts/desktop
          inputs.sops-nix.nixosModules.sops
        ];
      };

      server = inputs.nixpkgs.lib.nixosSystem {
        inherit specialArgs;
        modules = [
          ../hosts/server
        ];
      };
    };
}
