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
    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings, will be merged with defaults";
    };

    mod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
      description = "Mod key used in binds";
    };

    # Integrations (external dependencies)
    albertIntegration = lib.mkEnableOption "Enable Albert integration";
    regreet = lib.mkEnableOption "Enable regreet with greetd";
  };

  ### Configuration ###

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ ] ++ lib.optionals cfg.albertIntegration [ pkgs.albert ];

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

    services.greetd = lib.mkIf cfg.regreet {
      enable = true;

      settings = {
        default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland --config ${pkgs.writeText "hypr.conf" ''
            exec-once = ${pkgs.greetd.regreet}/bin/regreet; hyprctl dispatch exit
            misc {
              disable_hyprland_logo = true
              disable_splash_rendering = true
              disable_hyprland_qtutils_check = true
            }
          ''}";
        };
      };
    };

    programs.regreet.enable = cfg.regreet;

    home-manager.users.${config.host.user} = {
      wayland.windowManager.hyprland = {
        enable = true;

        # Disable systemd integration as it conflicts with UWSM
        systemd.enable = false;
        systemd.variables = [ "--all" ];

        # Hyprland settings
        settings = lib.mkMerge [
          settings
          cfg.extraSettings
        ];
      };
    };
  };
}
