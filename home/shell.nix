{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.home.shell;
in
{
  options.home.shell = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Shell module";
    };
  };

  config = lib.mkIf (cfg.enable) {
    # Make fish the default shell
    users.users.${config.sys.user}.shell = pkgs.fish;
    programs.fish.enable = true;

    home-manager.users.${config.sys.user} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          gh
          eza
          bat
          ripgrep
          fd
        ];

        programs.kitty = {
          enable = true;
          shellIntegration.enableFishIntegration = true;
          environment = {
            "EDITOR" = "nvim";
          };
        };

        programs.zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        programs.fzf = {
          enable = true;
          enableFishIntegration = true;
          defaultCommand = "fd --type f --hidden --follow --exclude .git";
          defaultOptions = [
            "--height 40%"
            "--layout=reverse"
            "--border"
          ];
        };

        programs.starship.enable = true;
        programs.fish = {
          enable = true;
          shellAliases = {
            ls = "eza";
            l = "eza -l";
            la = "eza -la";
            ll = "eza -lghH --git";
            cat = "bat";
            grep = "rg";
            find = "fd";
            tree = "eza --tree";
            cd = "z";
          };
        };
      };
  };
}
