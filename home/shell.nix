{
  atomazu,
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
        jq
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

      shellInit = {
        enable = atomazu.lib.mkEnableOption "Show fastfetch on shellInit" true;
        args = lib.mkOption {
          type = lib.types.str;
          default = ''--load-config "examples/8.jsonc"'';
          description = "fastfetch args when run on shellinit";
        };
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

      programs.direnv.enable = cfg.direnv.enable;
      programs.fastfetch = {
        enable = cfg.fastfetch.enable;
        settings = {
          logo = {
            source = pkgs.fetchurl {
              url = "https://avatanplus.com/files/resources/original/5a2a716939bda16035cb0315.png";
              sha256 = "sha256-RjqBJp9LcV+HC0Kw4nNlv0WuuQhipw/RlpFqtZZCfRg=";
            };
            width = 40;
          };
          modules = [
            "title"
            "separator"
            "datetime"
            "break"
            "os"
            "host"
            "kernel"
            "uptime"
            "packages"
            "shell"
            "break"
            "de"
            "wm"
            "theme"
            "icons"
            "font"
            "terminal"
            "break"
            "cpu"
            "gpu"
            "memory"
            "disk"
            "break"
            "player"
            "song"
            "break"
            "localip"
            "colors"
          ];
        };
      };

      programs.fish = lib.mkIf cfg.fish.enable {
        enable = true;
        interactiveShellInit =
          "set fish_greeting \n"
          + (lib.optionalString cfg.fastfetch.shellInit.enable (
            "fastfetch ${cfg.fastfetch.shellInit.args}" + "\n"
          ))
          + (lib.optionalString cfg.fastfetch.enable ''
            function myfetch
              set cols (tput cols)
              if test $cols -lt 80
                fastfetch --logo none
              else
                set width (math --scale=0 "min(40, max(8, $cols * 2 / 5))")
                fastfetch --logo-width $width
              end
            end
          '');

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
