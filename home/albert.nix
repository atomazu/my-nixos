{
  lib,
  config,
  ...
}:

let
  cfg = config.home.albert;
in
{
  options.home.albert = {
    enable = lib.mkEnableOption "Albert application launcher";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.sys.user} =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        home.packages = [ pkgs.albert ];

        # Custom Albert style
        home.activation = {
          copyAlbertTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
            target="${config.xdg.dataHome}/albert/widgetsboxmodel/themes/CUSTOM.qss"
            source="${./src/albert_style.qss}"
            targetDir="$(${pkgs.coreutils}/bin/dirname "$target")"
            ${pkgs.coreutils}/bin/mkdir -p "$targetDir"
            ${pkgs.coreutils}/bin/cp -f "$source" "$target"
          '';
        };

        xdg = {
          # Albert configuration
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
            "autostart/albert.desktop" = {
              text = lib.generators.toINI { } {
                "Desktop Entry" = {
                  Categories = "Utility;";
                  Comment = "A desktop agnostic launcher";
                  Exec = "albert --platform xcb";
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
