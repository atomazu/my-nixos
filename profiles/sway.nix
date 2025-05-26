{ config, lib, pkgs, ... }:

let 
  cfg = config.profiles;
in
{
  imports = [
    ./modules/waybar.nix
  ];

  ### Options ###

  options.profiles.sway = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Sway profile.";
    };
    mako.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable Mako notification service.";
    };
    wpaperd.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable wpaperd for wallpapers.";
    };
    tofi.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable tofi app launcher.";
    };
    foot.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable foot terminal emulator.";
    };
    waybar.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable waybar as info bar.";
    };
  };

  ### Configuration ###

  config = {
    home-manager.users.${config.sys.user} = lib.mkMerge [
      (lib.mkIf (cfg.sway.enable) {
        wayland.windowmanager.sway = {
          enable = true;

          wrapperfeatures.gtk = true;
          wrapperfeatures.base = true;
          xwayland = true;

          config = lib.mkMerge [
            (lib.mkIf (cfg.sway.tofi.enable) {
              menu = "${pkgs.tofi}/bin/tofi-run | xargs swaymsg exec --";
            })
            (lib.mkIf (cfg.sway.foot.enable) {
              terminal = "${pkgs.foot}/bin/foot";
            })
            (lib.mkIf (cfg.sway.waybar.enable) {
              bars = [{
                command = "${pkgs.waybar}/bin/waybar"; 
              }];
            })
            (lib.mkIf (cfg.sway.wpaperd.enable) {
              startup = [{
                command = "${pkgs.wpaperd}/bin/wpaperd"; 
              }];
            })
            ({
              modifier = "Mod4";
              window.titlebar = false;
            })
          ];
        };
      })
      (lib.mkIf (cfg.sway.wpaperd.enable && cfg.sway.enable) {
        programs.wpaperd = {
          enable = true;
          settings = {
            default = {
              path = "~/.nixos/assets/wallpaper.jpg";
            };
          };
        };
      })
      (lib.mkIf (cfg.sway.tofi.enable && cfg.sway.enable) {
        programs.tofi = {
          enable = true;
          settings = {
            anchor = "top";
            width = "100%";
            height = 24;
            horizontal = true;
            font-size = 12;
            prompt-text = " run: ";
            font = "monospace";
            outline-width = 0;
            border-width = 0;
            min-input-width = 120;
            result-spacing = 15;
            padding-top = 0;
            padding-bottom = 0;
            padding-left = 0;
            padding-right = 0;
          };
        };
      })
      (lib.mkIf (cfg.sway.mako.enable && cfg.sway.enable) {
        services.mako.enable = true;
      })
      (lib.mkIf (cfg.sway.waybar.enable && cfg.sway.enable) {
        programs.waybar.enable = true;
      })
    ];
  };
}
