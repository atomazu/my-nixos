{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.programs.ashell;
  tomlFormat = pkgs.formats.toml { };
in
{
  options.programs.ashell = {
    enable = mkEnableOption "ashell - a shell a la Material You";

    package = mkOption {
      type = types.package;
      default = pkgs.ashell;
      example = "inputs.ashell.defaultPackage.\${pkgs.system}";
      description = "The ashell package to use.";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = ''
        The raw attribute set for ashell configuration.
        This will be directly converted to TOML.
        Refer to ashell documentation for the expected structure.
      '';
      example = literalExpression ''
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

  config = mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."ashell/config.toml".source = tomlFormat.generate "ashell-config.toml" cfg.settings;
  };
}
