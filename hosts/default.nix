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

    stylix = {
      enable = lib.mkEnableOption "Enable Stylix";
      base16Scheme = lib.mkOption {
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
          size = 16;
        };
        description = "Cursor for stylix";
      };
    };

    nh = libutils.mkEnabledOption "If nh should be enabled";
  };

  ### Configuration ###

  config = {
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    stylix = {
      enable = cfg.stylix.enable;
      base16Scheme = cfg.stylix.base16Scheme;
      image = cfg.stylix.image;
      polarity = "dark";
      cursor = cfg.stylix.cursor;

      fonts = {
        sizes.terminal = 14;
        monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font";
        };
        serif = config.stylix.fonts.sansSerif;
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
      clean.extraArgs = "--keep-since 4d --keep 3";
    };

    system.stateVersion = "25.05";
  };
}
