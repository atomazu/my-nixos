{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home.shell;
in
{
  options.atomazu.my-nixos.home.shell = {
    enable = lib.mkEnableOption "Opinionated Shell Configuration";

    editor = lib.mkOption {
      type = lib.types.str;
      default = "nvim";
      description = "Default editor";
    };

    kitty = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Kitty terminal emulator";
      };

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.kitty;
        description = "Kitty package";
      };
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [
        gh
        ripgrep
        fd
      ];
      description = "Additional packages to install";
    };

    starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Starship prompt";
      };

      showNewline = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Add newline before prompt";
      };
    };

    eza = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Eza file listing";
      };

      git = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable git integration";
      };

      icons = lib.mkOption {
        type = lib.types.enum [
          "auto"
          "always"
          "never"
        ];

        default = "auto";
        description = "When to show icons";
      };
    };

    bat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Bat syntax highlighting";
      };

      pager = lib.mkOption {
        type = lib.types.str;
        default = "less -FR";
        description = "Pager to use";
      };
    };

    fzf = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "FZF fuzzy finder";
      };

      defaultCommand = lib.mkOption {
        type = lib.types.str;
        default = "fd --type f --hidden --follow --exclude .git";
        description = "Default command for FZF";
      };

      defaultOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];

        description = "Default options for FZF";
      };
    };

    direnv.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Direnv environment management";
    };
    zoxide.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Zoxide smart cd";
    };

    fastfetch = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Fastfetch system information";
      };

      config = lib.mkOption {
        type = lib.types.str;
        default = "examples/8.jsonc";
        description = "Fastfetch configuration to load";
      };
    };

    sessionVariables = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional session variables";
    };

    fish = {
      enable = lib.mkOption {
        type = lib.types.bool;
        description = "Smart and user-friendly command line shell";
        default = true;
      };

      aliases = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "Additional shell aliases";
      };
    };
  };

  config = lib.mkIf (cfg.enable) {
    users.users.${config.atomazu.my-nixos.host.user}.shell = lib.mkIf cfg.fish.enable pkgs.fish;
    programs.fish.enable = cfg.fish.enable;

    home-manager.users.${config.atomazu.my-nixos.host.user} = {
      home.packages = cfg.extraPackages;

      programs.kitty = lib.mkIf cfg.kitty.enable {
        enable = true;
        package = cfg.kitty.package;
        shellIntegration.enableFishIntegration = cfg.fish.enable;
      };

      home.sessionVariables = {
        EDITOR = cfg.editor;
      } // cfg.sessionVariables;

      programs.zoxide = lib.mkIf cfg.zoxide.enable {
        enable = true;
        enableFishIntegration = cfg.fish.enable;
      };

      programs.fzf = lib.mkIf cfg.fzf.enable {
        enable = true;
        enableFishIntegration = cfg.fish.enable;
        defaultCommand = cfg.fzf.defaultCommand;
        defaultOptions = cfg.fzf.defaultOptions;
      };

      programs.eza = lib.mkIf cfg.eza.enable {
        enable = true;
        enableFishIntegration = cfg.fish.enable;
        git = cfg.eza.git;
        icons = cfg.eza.icons;
      };

      programs.bat = lib.mkIf cfg.bat.enable {
        enable = true;
        config = {
          pager = cfg.bat.pager;
        };
      };

      programs.starship = lib.mkIf cfg.starship.enable {
        enable = true;
        enableFishIntegration = cfg.fish.enable;
        enableTransience = true;

        settings = {
          add_newline = cfg.starship.showNewline;
        };
      };

      programs.fastfetch.enable = cfg.fastfetch.enable;
      programs.direnv.enable = cfg.direnv.enable;

      programs.fish = lib.mkIf cfg.fish.enable {
        enable = true;
        interactiveShellInit = lib.mkIf cfg.fastfetch.enable ''
          set fish_greeting
          fastfetch --load-config ${cfg.fastfetch.config}
        '';
        shellAliases =
          (lib.optionalAttrs cfg.eza.enable {
            ls = "eza";
            tree = "eza --tree";
          })
          // (lib.optionalAttrs cfg.bat.enable {
            cat = "bat";
          })
          // (lib.optionalAttrs cfg.zoxide.enable {
            cd = "z";
          })
          // cfg.fish.aliases;
      };
    };
  };
}
