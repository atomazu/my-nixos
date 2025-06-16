{
  config,
  lib,
  pkgs,
  libutils,
  ...
}:

let
  cfg = config.profiles.hyprland;
  settings = import ./settings { inherit config pkgs lib; };
in
{
  ### Options ###

  options.profiles.hyprland = {
    osd = libutils.mkEnabledOption "Enable OSD for audio and brightness";
    enable = lib.mkEnableOption "Hyprland profile";
    playerctl = libutils.mkEnabledOption "Enable media playback controls";
    polkit = libutils.mkEnabledOption "Enable polkit auth agent";

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings, will be merged with defaults";
    };

    mod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
      description = "Mod key used in binds";
    };

    regreet = {
      enable = lib.mkEnableOption "Enable regreet with greetd";
      settings = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Appended to regreet hyprland settings";
      };
    };

    albert = {
      enable = lib.mkEnableOption "Enable Albert integration";
      keybind = lib.mkOption {
        type = lib.types.str;
        default = "$mod, SPACE";
        description = "Keybind for toggling Albert";
      };
    };
  };

  ### Configuration ###

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ ] ++ lib.optionals cfg.albert.enable [ pkgs.albert ];

    # For screensharing
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # To prevent Electron applications defaulting to X11
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Enable Hyprland with UWSM
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    programs.regreet.enable = cfg.regreet.enable;
    services.greetd = lib.mkIf cfg.regreet.enable {
      enable = true;

      settings = {
        default_session = {
          command = ''${pkgs.cage}/bin/cage -s -mlast -- ${pkgs.greetd.regreet}/bin/regreet'';
        };
      };
    };

    home-manager.users.${config.host.user} = {
      wayland.windowManager.hyprland = {
        enable = true;

        # Disable systemd integration as it conflicts with UWSM
        systemd.enable = false;
        systemd.variables = [ "--all" ];

        # Hyprland settings
        settings = lib.mkMerge [
          settings
          cfg.settings
        ];
      };
    };
  };
}
