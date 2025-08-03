{
  atomazu, config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-shell;
in
{
  options.atomazu.my-shell = {
    enable = lib.mkEnableOption "atomazu's desktop shell";
    package = lib.mkOption {
      type = lib.types.package;
      default = atomazu.inputs.quickshell.packages.${pkgs.system}.default;
      description = "The package to use";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "my-shell settings, refer to ${./src/Services/Config.qml} and related files";
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
    atomazu.quickshell = {
      enable = true;
      source = ./src;
      package = cfg.package;
      iconTheme = {
        name = cfg.iconTheme.name;
        package = cfg.iconTheme.package;
      };
      service = cfg.service;
      withholdEnv = cfg.withholdEnv;
      extraQmlPaths = cfg.extraQmlPaths;
      runtimeDependencies = cfg.runtimeDependencies;
    };

    home.activation = {
      quickshellSettings = atomazu.lib.mkWritable {
        from = (pkgs.writeText "quickshell-config.json" (pkgs.lib.generators.toJSON { } cfg.settings));
        to = ".config/quickshell/settings.json";
        after = "quickshell";
      };
    };
  };
}
