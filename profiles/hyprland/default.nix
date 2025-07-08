{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.hyprland;
  settings = import ./settings { inherit config pkgs lib; };
in
{
  ### Options ###

  options.profiles.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";

    playerctl = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Media playback controls (play, pause, next, previous)";
    };

    polkit = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Polkit authentication agent for elevated privileges";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Custom settings to override Hyprland defaults";
    };

    mod = lib.mkOption {
      type = lib.types.str;
      default = "SUPER";
      description = "Modifier key for keybindings (e.g., SUPER, ALT)";
    };

    osd = lib.mkEnableOption "On-screen display for volume and brightness notifications";
    albertIntegration = {
      enable = lib.mkEnableOption "Albert keyboard launcher integration";
      keybind = lib.mkOption {
        type = lib.types.str;
        default = "$mod, SPACE";
        description = "Keybinding to open the Albert launcher";
      };
    };
  };

  ### Configuration ###

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ ] ++ lib.optionals cfg.albertIntegration.enable [ pkgs.albert ];

    # For screensharing
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # To prevent Electron applications defaulting to X11
    environment.sessionVariables = {
      ANKI_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      CLUTTER_BACKEND = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    # Enable Hyprland with UWSM
    programs.hyprland = {
      enable = true;
      withUWSM = true;
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
