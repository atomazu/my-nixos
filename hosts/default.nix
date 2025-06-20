{
  inputs,
  config,
  pkgs,
  lib,
  libutils,
  ...
}:

let
  cfg = config.host;
  jp-cfg = cfg.extras.japanese;
in
{
  imports = [
    inputs.stylix.nixosModules.stylix
    ./../system
    ./../home
    ./../profiles
  ];

  ### Options ###

  options.host = {
    name = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the system";
    };

    user = lib.mkOption {
      type = lib.types.str;
      description = "The primary user of the system";
    };

    locale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The System locale";
    };

    extraLocale = lib.mkOption {
      type = lib.types.str;
      default = "en_US.UTF-8";
      description = "The System locale, but extra";
    };

    layout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = "Default keyboard layout";
    };

    time = lib.mkOption {
      type = lib.types.str;
      default = "Europe/Berlin";
      description = "Default system time";
    };

    stylix = {
      enable = libutils.mkEnabledOption "Enable Stylix";
      scheme = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        description = "Base 16 scheme to use for stylix";
      };

      image = lib.mkOption {
        type = lib.types.path;
        default = ../assets/binary.png;
        description = "Background image";
      };

      cursor = lib.mkOption {
        type = lib.types.attrs;
        default = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Classic";
          size = 24;
        };

        description = "Cursor for stylix";
      };
    };

    extras.jp = {
      enable = lib.mkEnableOption "Enable Japanese extras";

      fonts = {
        serif = lib.mkOption {
          type = lib.types.attrs;
          default = {
            package = pkgs.noto-fonts-cjk-serif;
            name = "Noto Serif CJK JP";
          };
          description = "Japanese serif font";
        };

        sansSerif = lib.mkOption {
          type = lib.types.attrs;
          default = {
            package = pkgs.noto-fonts-cjk-sans;
            name = "Noto Sans CJK JP";
          };
          description = "Japanese sans serif font";
        };
      };
    };

    nh = libutils.mkEnabledOption "If nh should be enabled";
  };

  ### Configuration ###

  config = {
    assertions = [
      {
        assertion = cfg.stylix.enable;
        message = "Disabling stylix is currently unsupported";
      }
    ];

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    stylix = {
      enable = cfg.stylix.enable;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/${cfg.stylix.scheme}.yaml";
      image = cfg.stylix.image;
      cursor = cfg.stylix.cursor;
      polarity = "dark";
      targets.grub.enable = false;
      targets.plymouth.enable = false;

      fonts = {
        sizes.terminal = 14;
        serif =
          if cfg.extras.jp.enable then
            cfg.extras.jp.fonts.serif
          else
            {
              package = pkgs.noto-fonts;
              name = "Noto Serif";
            };

        sansSerif =
          if cfg.extras.jp.enable then
            cfg.extras.jp.fonts.sansSerif
          else
            {
              package = pkgs.noto-fonts;
              name = "Noto Sans";
            };

        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };

        emoji = {
          package = pkgs.noto-fonts-emoji;
          name = "Noto Color Emoji";
        };
      };
    };

    users.users.${cfg.user} = {
      isNormalUser = true;
      description = "${cfg.user}";
      extraGroups = [
        "networkmanager"
        "wheel"
        "video"
      ];
    };

    programs.nh = {
      enable = cfg.nh;
      clean.enable = true;
      clean.extraArgs = "--keep 3";
    };

    time.hardwareClockInLocalTime = true;
    time.timeZone = "${cfg.time}";
    services.xserver.xkb.layout = cfg.layout;

    i18n = {
      defaultLocale = "${cfg.locale}";
      inputMethod = lib.mkIf cfg.extras.jp.enable {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-configtool
        ];
      };

      extraLocaleSettings = {
        LC_ADDRESS = "${cfg.extraLocale}";
        LC_IDENTIFICATION = "${cfg.extraLocale}";
        LC_MEASUREMENT = "${cfg.extraLocale}";
        LC_MONETARY = "${cfg.extraLocale}";
        LC_NAME = "${cfg.extraLocale}";
        LC_NUMERIC = "${cfg.extraLocale}";
        LC_PAPER = "${cfg.extraLocale}";
        LC_TELEPHONE = "${cfg.extraLocale}";
        LC_TIME = "${cfg.extraLocale}";
      };
    };

    system.stateVersion = "25.05";
  };
}
