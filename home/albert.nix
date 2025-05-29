{
  lib,
  config,
  ...
}:

let
  cfg = config.home.albert;
  nixConfig = config;
in
{
  options.home.albert = {
    enable = lib.mkEnableOption "Albert application launcher";
    xdg-autostart = lib.mkEnableOption "Add Albert to xdg-Autostart";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.sys.user} =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      let
        stylixColors = nixConfig.lib.stylix.colors.withHashtag;
        stylixFonts = nixConfig.stylix.fonts;

        albertQssContent = ''
          * {
            border: none;
            color: ${stylixColors.base05};
            background-color: ${stylixColors.base00};
            font-family: "${stylixFonts.sansSerif.name}", sans-serif;
          }

          #frame {
            padding: 3px;
            border-radius: 12px;
            background-color: ${stylixColors.base00};
            border: 1px solid ${stylixColors.base02};
            min-width: 560px;
            max-width: 560px;
          }

          #inputLine {
            padding: 6px 10px;
            border-radius: 8px;
            font-size: 22px;
            selection-color: ${stylixColors.base07};
            selection-background-color: ${stylixColors.base0D};
            background-color: ${stylixColors.base00};
            color: ${stylixColors.base05};
            border: none;
          }

          #settingsButton {
            color: transparent;
            background-color: transparent;
            border: none;
            padding: 0px;
            margin: 0px;
            border-radius: 0px;
            min-width: 0px;
            min-height: 0px;
            max-width: 0px;
            max-height: 0px;
          }

          QListView {
            selection-color: ${stylixColors.base07};
            selection-background-color: ${stylixColors.base01};
            background-color: ${stylixColors.base00};
            outline: none;
          }

          QListView::item {
            padding: 3px 6px;
            margin: 1px 0px;
            border-radius: 8px;
          }

          QListView::item:selected {
            background: ${stylixColors.base01};
            color: ${stylixColors.base07};
            border: 1px solid ${stylixColors.base03};
            border-radius: 8px;
            padding: 2px 5px;
          }

          QListView QScrollBar:vertical {
            width: 6px;
            background: transparent;
            margin: 1px 0 1px 0;
          }

          QListView QScrollBar::handle:vertical {
            background: ${stylixColors.base03};
            min-height: 20px;
            border-radius: 3px;
          }

          QListView QScrollBar::add-line:vertical,
          QListView QScrollBar::sub-line:vertical,
          QListView QScrollBar::up-arrow:vertical,
          QListView QScrollBar::down-arrow:vertical,
          QListView QScrollBar::add-page:vertical,
          QListView QScrollBar::sub-page:vertical {
            border: none;
            width: 0px;
            height: 0px;
            background: transparent;
          }

          QListView#actionList {
            font-size: 14px;
          }

          QListView#actionList::item {
            height: 24px;
            padding: 2px 6px;
          }

          QListView#actionList::item:selected {
              padding: 1px 5px;
          }

          QListView#resultsList {
            icon-size: 32px;
            font-size: 18px;
          }

          QListView#resultsList::item {
            height: 40px;
            padding: 3px 6px;
          }

          QListView#resultsList::item:selected {
              padding: 2px 5px;
          }

          QLineEdit[placeholderText] {
              color: ${stylixColors.base04};
          }

          QLineEdit[text=""] {
              color: ${stylixColors.base04};
          }
        '';

        themedAlbertQssFile = pkgs.writeText "CUSTOM.qss" albertQssContent;
      in
      {
        home.packages = [ pkgs.albert ];

        home.activation = {
          copyAlbertTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            target="${config.xdg.dataHome}/albert/widgetsboxmodel/themes/CUSTOM.qss"
            source="${themedAlbertQssFile}"
            targetDir="$(${pkgs.coreutils}/bin/dirname "$target")"
            ${pkgs.coreutils}/bin/mkdir -p "$targetDir"
            ${pkgs.coreutils}/bin/cp -f "$source" "$target"
          '';
        };

        xdg = {
          configFile = {
            "albert/config" = {
              text = lib.generators.toINI { } {
                General.telemetry = false;
                applications.enabled = true;
                calculator_qalculate.enabled = true;
                chromium.enabled = true;
                clipboard.enabled = true;
                debug.enabled = false;
                docs.enabled = false;
                python.enabled = false;
                websearch.enabled = true;

                system = {
                  enabled = true;
                  command_poweroff = "systemctl poweroff";
                  command_reboot = "systemctl reboot";
                  command_logout = "systemctl --user exit";
                };

                widgetsboxmodel = {
                  alwaysOnTop = true;
                  clearOnHide = false;
                  clientShadow = true;
                  darkTheme = "CUSTOM";
                  displayScrollbar = false;
                  followCursor = true;
                  hideOnFocusLoss = true;
                  historySearch = true;
                  itemCount = 5;
                  lightTheme = "CUSTOM";
                  quitOnClose = false;
                  showCentered = true;
                  systemShadow = true;
                };
              };
            };

            # Add Albert to xdg autostart
            "autostart/albert.desktop" = lib.mkIf cfg.xdg-autostart {
              text = lib.generators.toINI { } {
                "Desktop Entry" = {
                  Categories = "Utility;";
                  Comment = "A desktop agnostic launcher";
                  Exec = "${pkgs.albert}/bin/albert --platform xcb";
                  GenericName = "Launcher";
                  Icon = "albert";
                  Name = "Albert";
                  StartupNotify = false;
                  Type = "Application";
                  Version = "1.0";
                  "X-GNOME-Autostart-Delay" = 3;
                  "X-GNOME-Autostart-enabled" = true;
                  NoDisplay = false;
                  Hidden = false;
                  "Name[en_US]" = "Albert";
                  "Comment[en_US]" = "A desktop agnostic launcher";
                };
              };
            };
          };
        };
      };
  };
}
