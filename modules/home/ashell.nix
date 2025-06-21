{
  config,
  atmzInputs,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.atomazu.ashell;
in
{
  options.atomazu.ashell = {
    enable = lib.mkEnableOption "ashell - a shell a la Material You";

    package = lib.mkOption {
      type = lib.types.package;
      default = atmzInputs.ashell.defaultPackage.${pkgs.system};
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

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration to append to the ashell config.toml file.
        This raw string will be appended after the generated TOML configuration.
      '';
      example = ''
        # Custom raw TOML configuration
        [custom_section]
        some_option = "value"

        [another_section]
        enabled = true
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];
    xdg.configFile."ashell/config.toml".text =
      let
        generatedConfig = (pkgs.formats.toml { }).generate "ashell-config.toml" cfg.settings;
      in
      builtins.readFile generatedConfig
      + lib.optionalString (cfg.extraConfig != "") ("\n" + cfg.extraConfig);
  };
}
