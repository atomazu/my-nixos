{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./hyprland.nix
    ./blog.nix
  ];

  ### Settings ###

  atomazu.my-nixos = {
    enable = true;

    host = {
      name = "desktop";
      user = "jonas";
      locale = "en_US.UTF-8";
      extraLocale = "de_DE.UTF-8";
      layout = "us";
      extras = {
        jp.enable = true;
      };

      stylix = {
        scheme = "tomorrow-night";
      };
    };

    sys = {
      gpu.nvidia.enable = true;
      displayManager.gdm.enable = true;
      boot = {
        loader.grub = {
          enable = true;
          prober = true;
          res = "2560x1440";
        };
        silent = true;
        plymouth = true;
      };
    };

    home = {
      git = {
        enable = true;
        name = "atomazu";
        email = "contact@atomazu.org";
        signing = {
          enable = true;
          format = "ssh";
        };
      };

      chromium = {
        enable = true;
        widevine = true;
        extensions = {
          bitwarden = true;
          uBlockLite = true;
          darkReader = true;
          sponsorBlock = true;
          yomitan = true;
          malSync = true;
          vimium = true;
          websiteBlocker = true;
        };
      };

      shell = {
        enable = true;
      };

      yazi.enable = true;
      albert.enable = true;
      nixvim.enable = true;
      tmux.enable = true;
    };
  };

  ### Additional Tweaks ###
  home-manager.users.${config.atomazu.my-nixos.host.user} =
    { lib, ... }:
    {
      imports = [
        ../../modules/home/quickshell
      ];

      home.packages = with pkgs; [
        anki-bin
        youtube-music
        calibre
        wl-clipboard
      ];

      programs.vesktop.enable = true;
      programs.mpv.enable = true;

      atomazu.quickshell = {
        enable = true;
        configDir = ./quickshell;
        autoStart = true;
      };

      home.file =
        let
          colors = config.lib.stylix.colors.withHashtag;
          fonts = config.stylix.fonts;
        in
        {
          ".config/quickshell/settings.json" = {
            text = pkgs.lib.generators.toJSON { } {
              theme = {
                font = {
                  size = fonts.sizes.applications;
                  family = fonts.serif.name;
                };

                color00 = colors.base00; # Background
                color01 = colors.base01; # BackgroundLighter
                color02 = colors.base02; # Selection
                color03 = colors.base03; # Comment
                color04 = colors.base04; # ForegroundMuted
                color05 = colors.base05; # Foreground
                color06 = colors.base06; # ForegroundEmphasized
                color07 = colors.base07; # ForegroundBright
                color08 = colors.base08; # Red
                color09 = colors.base09; # Orange
                color0A = colors.base0A; # Yellow
                color0B = colors.base0B; # Green
                color0C = colors.base0C; # Cyan
                color0D = colors.base0D; # Blue
                color0E = colors.base0E; # Magenta
                color0F = colors.base0F; # Brown
              };

              bar = {
                position = "top";
              };
            };
          };
        };

      home.activation.quickshellSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        # Replace symlink with actual file
        if [ -L "$HOME/.config/quickshell/settings.json" ]; then
          $DRY_RUN_CMD rm -f "$HOME/.config/quickshell/settings.json.tmp"
          $DRY_RUN_CMD cp -f "$(readlink -f "$HOME/.config/quickshell/settings.json")" "$HOME/.config/quickshell/settings.json.tmp"
          $DRY_RUN_CMD mv "$HOME/.config/quickshell/settings.json.tmp" "$HOME/.config/quickshell/settings.json"
        fi
      '';
    };
}
