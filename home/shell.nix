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
    font-size = lib.mkOption {
      type = lib.types.int;
      default = 16;
      description = "Font Size for Kitty";
    };
  };

  config = lib.mkIf (cfg.enable) {
    # Make fish the default shell
    users.users.${config.host.user}.shell = pkgs.fish;
    programs.fish.enable = true;

    home-manager.users.${config.host.user} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          gh
          ripgrep
          fd
        ];

        programs.kitty = {
          enable = true;
          shellIntegration.enableFishIntegration = true;
        };

        home.sessionVariables = {
          EDITOR = "nvim";
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

        programs.eza = {
          enable = true;
          enableFishIntegration = true;
          git = true;
          icons = "auto";
        };

        programs.direnv = {
          enable = true;
        };

        programs.bat = {
          enable = true;
          config = {
            pager = "less -FR";
          };
        };

        programs.starship = {
          enable = true;
          enableFishIntegration = true;
          enableTransience = true;

          settings = {
            add_newline = false;
          };
        };

        programs.fastfetch.enable = true;

        programs.fish = {
          enable = true;
          interactiveShellInit = ''
            set fish_greeting
            fastfetch --load-config examples/8.jsonc
          '';
          shellAliases = {
            ls = "eza";
            l = "eza -l";
            la = "eza -la";
            ll = "eza -lghH";
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
