{ config, lib, inputs, ... }:

{
  home-manager.users.${config.sys.user} = {
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

    programs.chromium = {
      enable = true;
      # These make it lag for some reason.
      # commandLineArgs = [
      #   "--ignore-gpu-blocklist"
      #   "--use-gl=egl"
      #   "--ozone-platform-hint=auto"
      # ];

      extensions = [
        { id = "nngceckbapebfimnlniiiahkandclblb"; } # Bitwarden
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark-Reader
      ];
    };

    home.stateVersion = "24.11";
  };
}
