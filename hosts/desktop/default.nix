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

  # --- Settings ---

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

      youtube-music.enable = true;

      yazi.enable = true;
      albert.enable = true;
      nixvim.enable = true;
      tmux.enable = true;
    };
  };

  # --- Additional Tweaks ---

  home-manager.users.${config.atomazu.my-nixos.host.user} =
    { lib, ... }:
    let
      colors = config.lib.stylix.colors.withHashtag;
      fonts = config.stylix.fonts;
      qsPath = ".config/quickshell/settings.json";
    in
    {
      home.packages = with pkgs; [
        anki-bin
        calibre
        wl-clipboard
      ];

      programs.vesktop.enable = true;
      programs.mpv.enable = true;

      # --- Quickshell Begin ---

      atomazu.quickshell = {
        enable = true;
        configDir = ./quickshell;
        service = true;
      };

      home.file = {
        "${qsPath}" = {
          text = pkgs.lib.generators.toJSON { } {
            theme = {
              font = {
                size = fonts.sizes.applications;
                family = fonts.serif.name;
              };

              # Idea: Make it accept a base16 file instead
              color00 = colors.base00;
              color01 = colors.base01;
              color02 = colors.base02;
              color03 = colors.base03;
              color04 = colors.base04;
              color05 = colors.base05;
              color06 = colors.base06;
              color07 = colors.base07;
              color08 = colors.base08;
              color09 = colors.base09;
              color0A = colors.base0A;
              color0B = colors.base0B;
              color0C = colors.base0C;
              color0D = colors.base0D;
              color0E = colors.base0E;
              color0F = colors.base0F;
            };

            bar = {
              position = "top";
            };

            stylix = config.lib.stylix.colors;
          };
        };
      };

      home.activation.quickshellSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.config/quickshell"
        CONFIG_PATH="$HOME/${qsPath}"
        if [ -L "$CONFIG_PATH" ]; then
          $DRY_RUN_CMD cp -f "$(readlink -f "$CONFIG_PATH")" "$CONFIG_PATH.tmp"
          $DRY_RUN_CMD mv "$CONFIG_PATH.tmp" "$CONFIG_PATH"
        fi
        $DRY_RUN_CMD chmod -R u+w "$HOME/${qsPath}"
      '';

      # --- Quickshell End ---
    };

}
