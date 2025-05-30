{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.sway;
in
{
  imports = [
    ./modules/waybar.nix
  ];

  options.profiles.sway = {
    enable = lib.mkEnableOption "Sway profile";
  };

  config = lib.mkIf (cfg.enable == true) {
    home-manager.users.${config.host.user} = {
      wayland.windowmanager.sway = {
        enable = true;

        wrapperfeatures.gtk = true;
        wrapperfeatures.base = true;
        xwayland = true;

        config = {
          menu = "${pkgs.tofi}/bin/tofi-run | xargs swaymsg exec --";
          terminal = "${pkgs.foot}/bin/foot";
          bars = [
            {
              command = "${pkgs.waybar}/bin/waybar";
            }
          ];
          startup = [
            {
              command = "${pkgs.wpaperd}/bin/wpaperd";
            }
          ];
          modifier = "Mod4";
          window.titlebar = false;
        };
      };

      programs.wpaperd = {
        enable = true;
        settings = {
          default = {
            path = ./../assets/binary.png;
          };
        };
      };

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

      services.mako.enable = true;
      programs.waybar.enable = true;
    };
  };
}
