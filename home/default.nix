{
  atomazu,
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home;
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

  options.atomazu.my-nixos.home = {
    nixvim.enable = lib.mkEnableOption "Nix-managed Neovim configuration";
  };

  config.home-manager = lib.mkIf config.atomazu.my-nixos.enable {
    extraSpecialArgs = { inherit atomazu; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.${config.atomazu.my-nixos.host.user} = {
      imports = [
        ../modules/home
      ];

      atomazu.nixvim.enable = cfg.nixvim.enable;
      home.stateVersion = "25.05";
    };
  };
}
