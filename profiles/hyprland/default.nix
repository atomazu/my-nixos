{
  atomazu,
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.atomazu.my-nixos.profiles.hyprland;
  settings = import ./settings { inherit config pkgs lib; };
in
{
  ### Options ###

  options.atomazu.my-nixos.profiles.hyprland = {
    enable = lib.mkEnableOption "Hyprland Wayland compositor";

    playerctl.enable = atomazu.lib.mkEnableOption "Media playback controls (play, pause, next, previous)" true;
    polkit.enable = atomazu.lib.mkEnableOption "Polkit authentication agent for elevated privileges" true;

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

    launcher = {
      enable = lib.mkEnableOption "Keyboard launcher integration";

      keybind = lib.mkOption {
        type = lib.types.str;
        default = "$mod, R";
        description = "Keybinding to open the launcher";
      };

      command = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.albert}/bin/albert toggle";
        description = "Command to execute when launcher keybind is pressed";
      };

      windowRules = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "noborder, title:Albert"
          "noblur, title:Albert"
          "noshadow, title:Albert"
        ];
        description = "Window rules for the launcher window";
      };
    };

    hyprsunset = {
      enable = lib.mkEnableOption "Blue light filter toggle with hyprsunset";

      keybind = lib.mkOption {
        type = lib.types.str;
        default = "$mod, N";
        description = "Keybinding to toggle hyprsunset";
      };

      temperature = lib.mkOption {
        type = lib.types.int;
        default = 3250;
        description = "Color temperature in Kelvin (lower = warmer/more red)";
      };

      gamma = lib.mkOption {
        type = lib.types.int;
        default = 65;
        description = "Gamma correction value (0-100, lower = darker)";
      };
    };

    osd = {
      enable = lib.mkEnableOption "On-screen display for volume and brightness notifications";

      serverCmd = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = "${pkgs.swayosd}/bin/swayosd-server";
        description = "Command to start the OSD server. Set to null if no server is needed.";
      };

      commands = {
        volumeRaise = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.swayosd}/bin/swayosd-client --output-volume raise --max-volume 100";
          description = "Command to raise volume";
        };

        volumeLower = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.swayosd}/bin/swayosd-client --output-volume lower --max-volume 100";
          description = "Command to lower volume";
        };

        volumeToggle = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle";
          description = "Command to toggle volume mute";
        };

        micToggle = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle";
          description = "Command to toggle microphone mute";
        };

        brightnessUp = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.swayosd}/bin/swayosd-client --brightness raise";
          description = "Command to increase brightness";
        };

        brightnessDown = lib.mkOption {
          type = lib.types.str;
          default = "${pkgs.swayosd}/bin/swayosd-client --brightness lower";
          description = "Command to decrease brightness";
        };
      };
    };
  };

  ### Configuration ###

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    environment.sessionVariables = {
      ANKI_WAYLAND = "1";
      SDL_VIDEODRIVER = "wayland";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      CLUTTER_BACKEND = "wayland";
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };

    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    home-manager.users.${config.atomazu.my-nixos.host.user} = {
      wayland.windowManager.hyprland = {
        enable = true;

        # Disable systemd integration as it conflicts with UWSM
        systemd.enable = false;
        systemd.variables = [ "--all" ];

        settings = lib.mkMerge [
          settings
          cfg.settings
        ];
      };
    };
  };
}
