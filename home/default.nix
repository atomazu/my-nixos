{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./nixvim.nix
    ./tmux.nix
    ./vim.nix
  ];

  programs.git = {
    enable = true;
    userName = "atomazu";
    userEmail = "contact@atomazu.org";
  };

  home.stateVersion = "24.11";
}
