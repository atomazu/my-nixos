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
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.sys.user} = {
      imports = [
        ../modules/home/ashell.nix
      ];
      programs.ashell = {
        enable = cfg.enable;
        package = inputs.ashell.defaultPackage.${pkgs.system};

        settings = {
          # Ashell log level filter, possible values "debug" | "info" | "warn" | "error". Needs reload.
          log_level = "warn"; # Default

          # Possible status bar outputs.
          # "All": the status bar will be displayed on all available outputs.
          # "Active": the status bar will be displayed on the active output.
          # { targets = ["DP-1", "eDP-1"] }: the status bar will be displayed on the outputs listed.
          # If the specified output is not available, the bar will be displayed on the active output.
          outputs = "All"; # Default
          # Other options:
          # outputs = "Active";
          # outputs = { targets = [ "DP-1" "eDP-1" ]; };

          # Bar position, possible values "Top" | "Bottom".
          # position = "Top"; # Default
          # Other option:
          position = "Bottom";

          # App launcher command, it will be used to open the launcher.
          # Without a value, the related button will not appear.
          # Optional, default null.
          # app_launcher_cmd = "~/.config/rofi/launcher.sh";

          # Clipboard command, it will be used to open the clipboard menu.
          # Without a value, the related button will not appear.
          # Optional, default null.
          # clipboard_cmd = "cliphist-rofi-img | wl-copy";

          # Maximum number of chars that can be present in the window title.
          # After that, the title will be truncated.
          # Optional, default 150.
          truncate_title_after_length = 150;

          # Declare which modules should be used and in which position in the status bar.
          modules = {
            # The modules that will be displayed on the left side of the status bar.
            left = [ "Workspaces" ]; # Default
            # The modules that will be displayed in the center of the status bar.
            center = [ "WindowTitle" ]; # Default
            # The modules that will be displayed on the right side of the status bar.
            # The nested modules array will form a group sharing the same element in the status bar.
            right = [
              [
                "Clock"
                "Privacy"
                "Settings"
              ]
            ]; # Default
          };

          # Update module configuration.
          # Without this section, the related button will not appear.
          # Optional, default null.
          # updates = {
          # The check command will be used to retrieve the update list.
          # It should return something like `package_name version_from -> version_to\n`
          # check_cmd = "checkupdates; paru -Qua";
          # The update command is used to init the OS update process.
          # update_cmd = ''alacritty -e bash -c "paru; echo Done - Press enter to exit; read"'';
          # };

          # Workspaces module configuration. Optional.
          workspaces = {
            # The visibility mode of the workspaces, possible values are: "All" | "MonitorSpecific".
            # Optional, default "All".
            # visibility_mode = "All";
            # Other option:
            visibility_mode = "MonitorSpecific";

            # Enable filling with empty workspaces.
            # Optional, default false.
            # enable_workspace_filling = true;

            # If you want to see more workspaces prefilled, set the number here.
            # Only works with `enable_workspace_filling = true`.
            # Optional, default null.
            # max_workspaces = 10;
          };

          # KeyboardLayout module configuration. Optional.
          # Maps layout names to arbitrary labels, which can be any text, including unicode symbols.
          keyboard_layout = {
            labels = {
              # "English (US)" = "🇺🇸";
              # "Russian" = "🇷🇺";
            }; # Default: {}
          };

          # The system module configuration. Optional.
          system = {
            # System information shown in the status bar.
            # Possible values: "Cpu", "Memory", "MemorySwap", "Temperature",
            # { disk = "/path" }, "IpAddress", "DownloadSpeed", "UploadSpeed".
            indicators = [
              "Cpu"
              "Memory"
              "Temperature"
            ]; # Default
            # Example with disk usage:
            # indicators = [ { disk = "/"; } { disk = "/home"; } "Cpu" "Memory" ];

            # CPU indicator thresholds. Optional.
            cpu = {
              # Default
              warn_threshold = 60;
              alert_threshold = 80;
            };

            # Memory indicator thresholds. Optional.
            memory = {
              # Default
              warn_threshold = 70;
              alert_threshold = 85;
            };

            # Temperature indicator thresholds. Optional.
            temperature = {
              # Default
              warn_threshold = 60;
              alert_threshold = 80;
            };

            # Disk indicator thresholds. Optional.
            disk = {
              # Default
              warn_threshold = 80;
              alert_threshold = 90;
            };
          };

          # Clock module configuration.
          clock = {
            # Clock format, see: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
            format = "%a %d %b %R"; # Default
          };

          # Media player module configuration.
          media_player = {
            # Maximum length of the media player title.
            # Optional, default 100.
            max_title_length = 100;
          };

          # Settings module configuration.
          settings = {
            # Command used to lock the system.
            # Optional, default null.
            # lock_cmd = "hyprlock &";

            # Command used to open the sinks audio settings.
            # Optional, default null.
            # audio_sinks_more_cmd = "pavucontrol -t 3";

            # Command used to open the sources audio settings.
            # Optional, default null.
            # audio_sources_more_cmd = "pavucontrol -t 4";

            # Command used to open the network settings.
            # Optional, default null.
            # wifi_more_cmd = "nm-connection-editor";

            # Command used to open the VPN settings.
            # Optional, default null.
            # vpn_more_cmd = "nm-connection-editor";

            # Command used to open the Bluetooth settings.
            # Optional, default null.
            # bluetooth_more_cmd = "blueman-manager";
          }; # Default: all null

          # Appearance config.
          appearance = {
            # Font name to use. Optional, default is null (iced.rs default font).
            font_name = stylixFonts.sansSerif.name;

            # The style of the main bar, possible values are: "Islands" | "Solid" | "Gradient".
            style = "Solid"; # Default

            # The opacity of the main bar, possible values are: 0.0 to 1.0.
            opacity = 1.0; # Default

            # Menu options.
            menu = {
              # Default
              opacity = 1.0;
              backdrop = 0.0;
            };

            # Used as a base background color.
            background_color = {
              base = stylixColors.base00;
            }; # Default base: "#1e1e2e"

            # Used as an accent color.
            primary_color = {
              base = stylixColors.base0A;
              text = stylixColors.base00;
            }; # Default base: "#fab387", text: "#1e1e2e"

            # Used for darker background color.
            secondary_color = {
              base = stylixColors.base01;
            }; # Default base: "#11111b"

            # Used for success message or happy state.
            success_color = stylixColors.base0B; # Default: "#a6e3a1"

            # Used for danger message or danger state.
            danger_color = {
              base = stylixColors.base08;
              weak = stylixColors.base0A;
            }; # Default base: "#f38ba8", weak: "#f9e2af"

            # Base default text color.
            text_color = stylixColors.base05; # Default: "#cdd6f4"

            # List of colors for workspaces (one for each monitor).
            workspace_colors = [
              # Default: [ "#fab387", "#b4befe", "#cba6f7" ]
              stylixColors.base0A # orange
              stylixColors.base0D # blue
              stylixColors.base0E # purple
            ];

            # List of colors for special workspaces.
            # Optional, default null (uses workspace_colors if not set).
            # special_workspace_colors = [
            #   stylixColors.base0B # Green
            #   stylixColors.base08 # Red
            # ];
          };
        };
      };
    };
  };
}
