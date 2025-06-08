{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.home.ashell;
  stylixColors = config.lib.stylix.colors.withHashtag;
  stylixFonts = config.stylix.fonts;
in
{
  options.home.ashell = {
    enable = lib.mkEnableOption "Enable Ashell status bar";
    swayncIntegration = lib.mkEnableOption "Integrates swaync";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.host.user} = {
      atomazu.ashell = {
        enable = cfg.enable;
        package = inputs.ashell.defaultPackage.${pkgs.system};

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
              "CustomNotifications"
              "Settings"
            ];
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
