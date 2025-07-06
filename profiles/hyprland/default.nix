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
    osd = libutils.mkEnabledOption "On-screen display for volume and brightness notifications";
    enable = lib.mkEnableOption "Hyprland Wayland compositor";
    playerctl = libutils.mkEnabledOption "Media playback controls (play, pause, next, previous)";
    polkit = libutils.mkEnabledOption "Polkit authentication agent for elevated privileges";

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

    regreet = {
      enable = lib.mkEnableOption "Regreet login manager with greetd";
      settings = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Additional settings for the Regreet login manager";
      };
    };

    albert = {
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
