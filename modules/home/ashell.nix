{
  config,
  inputs,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.ashell;
in
{
  options.programs.ashell = {
    enable = lib.mkEnableOption "ashell - a shell a la Material You";

    package = lib.mkOption {
      type = lib.types.package;
      default = inputs.ashell.defaultPackage.${pkgs.system};
      description = "The ashell package to use.";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = ''
        The raw attribute set for ashell configuration.
        This will be directly converted to TOML.
        Refer to ashell documentation for the expected structure.
      '';
      example = lib.literalExpression ''
        {
          log_level = "warn";
          outputs = "All";
          modules = {
            left = [ "Workspaces" ];
            center = [ "WindowTitle" ];
            right = [ "SystemInfo" [ "Clock" "Privacy" "Settings" ] ];
          };
          appearance.font_name = "JetBrains Mono";
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."ashell/config.toml".source =
      (pkgs.formats.toml { }).generate "ashell-config.toml"
        cfg.settings;
  };
}
