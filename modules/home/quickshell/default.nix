{
  pkgs,
  config,
  lib,
  atmzInputs,
  ...
}:
let
  cfg = config.atomazu.quickshell;
  env = {
    QS_ICON_THEME = cfg.iconTheme;
    QT_PLUGIN_PATH = "${pkgs.qt6.qtbase}/${pkgs.qt6.qtbase.qtPluginPrefix}";
    QML2_IMPORT_PATH = lib.makeSearchPath "lib/qt-6/qml" (
      [
        pkgs.qt6.qtdeclarative
        pkgs.qt6.qtbase.qtQmlPrefix
        pkgs.kdePackages.qt5compat
        pkgs.kdePackages.qtsvg
        cfg.package
      ]
      ++ cfg.extraQmlPaths
    );
  };
in
{
  options.atomazu.quickshell = {
    enable = lib.mkEnableOption "Widget system for creating your own shell using QtQuick";

    package = lib.mkOption {
      type = lib.types.package;
      default = atmzInputs.quickshell.packages.${pkgs.system}.default;
      description = "Quickshell package to use";
    };

    configDir = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to Quickshell configuration directory";
    };

    iconTheme = lib.mkOption {
      type = lib.types.str;
      default = "Papirus";
      description = "Icon theme to use for Quickshell";
    };

    autoStart = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to auto-start Quickshell on login";
    };

    extraQmlPaths = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to add to QML import path";
    };

    runtimeDependencies = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = with pkgs; [ papirus-icon-theme ];
      description = "Runtime dependencies for Quickshell";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ cfg.runtimeDependencies;

    home.file = lib.mkIf (cfg.configDir != null) {
      ".config/quickshell" = {
        source = cfg.configDir;
        recursive = true;
      };
    };

    home.sessionVariables = env;

    systemd.user.services.quickshell = lib.mkIf cfg.autoStart {
      Unit = {
        Description = "Quickshell";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/quickshell";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        EnvironmentFile = pkgs.writeText "quickshell.env" (
          lib.generators.toINIWithGlobalSection { } { globalSection = env; }
        );
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.desktopEntries.quickshell = {
      name = "Quickshell";
      comment = "QtQuick based desktop shell";
      exec = "${cfg.package}/bin/quickshell";
      icon = "quickshell";
      terminal = false;
      type = "Application";
      categories = [ "System" ];
    };
  };
}
