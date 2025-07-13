{
  config,
  lib,
  atmzInputs,
  ...
}:

let
  cfg = config.home;
in
{
  imports = [
    atmzInputs.home-manager.nixosModules.default
    ./tmux.nix
    ./vim.nix
    ./albert.nix
    ./shell.nix
    ./ashell.nix
    ./yazi.nix
    ./git.nix
    ./chromium.nix
    ./firefox.nix
  ];

  options.home = {
    nixvim.enable = lib.mkEnableOption "Nix-managed Neovim configuration";
  };

  config = {
    home-manager = {
      extraSpecialArgs = { inherit atmzInputs; };
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    home-manager.users.${config.host.user} = {
      imports = [
        ../modules/home
      ];

      atomazu.nixvim.enable = cfg.nixvim.enable;
      home.stateVersion = "25.05";
    };
  };
}
