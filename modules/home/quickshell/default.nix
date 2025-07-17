{
  pkgs,
  config,
  lib,
  atomazu,
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
      default = atomazu.inputs.quickshell.packages.${pkgs.system}.default;
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

    home.activation.quickshellConfig = (
      lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        $DRY_RUN_CMD mkdir -p "$HOME/.config/quickshell"
        $DRY_RUN_CMD cp -rf ${cfg.configDir}/* "$HOME/.config/quickshell/"
        $DRY_RUN_CMD chmod -R u+w "$HOME/.config/quickshell"
      ''
    );

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
  };
}
