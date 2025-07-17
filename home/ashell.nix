{
  pkgs,
  config,
  lib,
  atomazu,
  ...
}:

let
  cfg = config.home.ashell;
  stylixColors = config.lib.stylix.colors.withHashtag;
  stylixFonts = config.stylix.fonts;
in
{
  options.home.ashell = {
    enable = lib.mkEnableOption "ashell - a shell a la Material You";
    swayncIntegration = lib.mkEnableOption "Sway Notification Center Integration";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.host.user} = {
      services.swaync.enable = cfg.swayncIntegration;
      services.swaync.settings = {
        control-center-margin-top = 8;
        control-center-margin-bottom = 8;
        control-center-margin-right = 8;
        control-center-margin-left = 8;
        control-center-width = 500;
        control-center-height = 600;
        positionX = "right";
        positionY = "bottom";
      };

      atomazu.ashell = {
        enable = cfg.enable;
        package = atomazu.inputs.ashell.defaultPackage.${pkgs.system};

        extraConfig = lib.mkIf cfg.swayncIntegration ''
          [[CustomModule]]
          name = "CustomNotifications"
          icon = ""
          command = "swaync-client -t -sw"
          listen_cmd = "swaync-client -swb"
          icons.'dnd.*' = ""
          alert = ".*notification"
        '';

        settings = {
          log_level = "warn";
          outputs = "All";
          position = "Bottom";

          modules = {
            left = [
              "Workspaces"
              "SystemInfo"
              "WindowTitle"
            ];
            right = [
              "MediaPlayer"
              "Tray"
              "Clock"
              "Settings"
            ] ++ lib.optionals cfg.swayncIntegration [ "CustomNotifications" ];

          };

          workspaces = {
            visibility_mode = "MonitorSpecific";
          };

          clock = {
            format = "%a %d %b %R";
          };

          media_player = {
            max_title_length = 50;
          };

          appearance = {
            font_name = stylixFonts.sansSerif.name;
            style = "Solid";
            opacity = 1.0;

            menu = {
              opacity = 1.0;
              backdrop = 0.0;
            };

            background_color = {
              base = stylixColors.base00;
            };

            primary_color = {
              base = stylixColors.base0A;
              text = stylixColors.base00;
            };

            secondary_color = {
              base = stylixColors.base01;
            };

            success_color = stylixColors.base0B;

            danger_color = {
              base = stylixColors.base08;
              weak = stylixColors.base0A;
            };

            text_color = stylixColors.base05;

            workspace_colors = [
              stylixColors.base0A
              stylixColors.base0D
              stylixColors.base0E
            ];
          };
        };
      };
    };
  };
}
