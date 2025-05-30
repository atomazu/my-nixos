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
    makoIntegration = libutils.mkEnabledOption "Enable mako notification daemon";
  };

  ### Configuration ###

  config = lib.mkIf cfg.enable {
    # Dependencies
    environment.systemPackages =
      [ pkgs.wl-clipboard ]
      ++ lib.optionals cfg.polkit [ pkgs.hyprpolkitagent ]
      ++ lib.optionals cfg.osd [ pkgs.swayosd ]
      ++ lib.optionals cfg.playerctl [ pkgs.playerctl ];

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

    home-manager.users.${config.sys.user} = {
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
