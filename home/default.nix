{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.home;
in
{
  options.home = {
    git.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable git";
    };

    chromium.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable chromium";
    };

    albert.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable albert application launcher";
    };
  };

  config = {
    home-manager.users.${config.sys.user} = {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
        ./nixvim.nix
        ./tmux.nix
        ./vim.nix
        ./albert.nix
      ];

      programs.git = {
        enable = cfg.git.enable;
        userName = "atomazu";
        userEmail = "contact@atomazu.org";
      };

      programs.chromium = {
        enable = cfg.chromium.enable;

        extensions = [
          { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden Password Manager
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
          { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
          { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock
        ];
      };

      home.stateVersion = "24.11";
    };
  };
}
