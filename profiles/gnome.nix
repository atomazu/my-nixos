{ config, lib, pkgs, ... }:

let 
  cfg = config.profiles;
in
{
  # imports = [];

  ### Options ###

  options.profiles.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Gnome profile.";
    };
  };

  ### Configuration ###

  config = (lib.mkIf (cfg.gnome.enable) ({
    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
    ];

    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.core-utilities.enable = false;
    
    home-manager.users.${config.sys.user} = lib.mkMerge [
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
            speed = 0.33834586466165417;
          };

          "org/gnome/desktop/background" = {
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
            picture-uri-dark = "file:///run/current-system/sw/share/backgrounds/gnome/amber-d.jxl";
            primary-color = "#ff7800";
            picture-options = "zoom";          };

          "org/gnome/desktop/screensaver" = {
            picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/amber-l.jxl";
            primary-color = "#ff7800";
            picture-options = "zoom";
          };
        };
      }
    ];
  }));
}
