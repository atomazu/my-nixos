{
  pkgs,
  config,
  lib,
  atomazu,
  ...
}:
let
  cfg = config.atomazu.quickshell;
  env =
    {
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
    }
    // lib.optionalAttrs (cfg.iconTheme.name != null) {
      QS_ICON_THEME = cfg.iconTheme.name;
    };
in
{
  options.atomazu.quickshell = {
    enable = lib.mkEnableOption "Widget system for creating your own shell using QtQuick";

    package = lib.mkOption {
      type = lib.types.package;
      default = atomazu.inputs.quickshell.packages.${pkgs.system}.default;
      description = "Quickshell package to use";
    };

    source = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Path to Quickshell configuration directory";
    };

    iconTheme = {
      name = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Name of icon theme to use, if null uses system default";
      };
      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        default = null;
        description = "Package containing the icon theme, assumes it's globally available if null";
      };
    };

    service = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Auto start Quickshell using a Systemd service";
    };

    withholdEnv = lib.mkEnableOption "Withholding of Quickshell environment from user session";

    extraQmlPaths = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional packages to add to QML import path";
    };

    runtimeDependencies = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Runtime dependencies for Quickshell";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ] ++ cfg.runtimeDependencies;

    home.sessionVariables = lib.mkIf (!cfg.withholdEnv) env;
    home.activation."quickshell" = atomazu.lib.mkWritable {
      from = "${cfg.source}";
      to = ".config/quickshell";
      also = "run touch $HOME/.config/quickshell/.qmlls.ini";
    };

    systemd.user.services.quickshell = atomazu.lib.mkAutoStart {
      name = "Quickshell";
      exec = "${cfg.package}/bin/quickshell";
      env = pkgs.writeText "quickshell.env" (
        lib.generators.toINIWithGlobalSection { } { globalSection = env; }
      );
    };
  };
}
