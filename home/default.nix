{
  atomazu,
  config,
  lib,
  ...
}:

let
  cfg = config.home;
in
{
  imports = [
    atomazu.inputs.home-manager.nixosModules.default
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

  config.home-manager = {
    extraSpecialArgs = { inherit atomazu; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${config.host.user} = {
      imports = [
        ../modules/home
      ];

      atomazu.nixvim.enable = cfg.nixvim.enable;
      home.stateVersion = "25.05";
    };
  };
}
