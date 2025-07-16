{ inputs, ... }:
{
  flake.nixosConfigurations =
    let
      system = "x86_64-linux";
      libutils = import ../lib { lib = inputs.nixpkgs.lib; };
      specialArgs = {
        atmzInputs = inputs;
        inherit libutils;
        inherit (inputs) quickshell;
      };
    in
    {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../hosts/desktop
          inputs.sops-nix.nixosModules.sops
        ];
      };

      server = inputs.nixpkgs.lib.nixosSystem {
        inherit system specialArgs;
        modules = [
          ../hosts/server
        ];
      };
    };
}
