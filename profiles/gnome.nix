{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles;
in
{
  ### Options ###

  options.profiles.gnome = {
    enable = lib.mkEnableOption "GNOME profile";
  };

  ### Configuration ###

  config = (
    lib.mkIf (cfg.gnome.enable) {
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
      ];

      services.displayManager.gdm.enable = true;
      services.desktopManager.gnome.enable = true;
      services.gnome.core-utilities.enable = false;

      home-manager.users.${config.host.user} = lib.mkMerge [
        {
          dconf.settings = {
            "org/gnome/settings-daemon/plugins/color" = {
              night-light-enabled = true;
              night-light-temperature = 4700;
              night-light-schedule-from = 21.0;
            };

            "org/gnome/desktop/interface" = {
              color-scheme = "prefer-dark";
              enable-hot-corners = true;
            };

            "org/gnome/mutter" = {
              edge-tiling = true;
              dynamic-workspaces = true;
              workspaces-only-on-primary = false;
            };

            "org/gnome/shell/app-switcher" = {
              current-workspace-only = false;
            };

            "org/gnome/desktop/peripherals/mouse" = {
              accel-profile = "flat";
              speed = 0.333;
            };

            "org/gnome/desktop/background" = {
              picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
              picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/amber-d.jxl";
              primary-color = "#ff7800";
              picture-options = "zoom";
            };

            "org/gnome/desktop/screensaver" = {
              picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
              primary-color = "#ff7800";
              picture-options = "zoom";
            };
          };
        }
      ];
    }
  );
}
