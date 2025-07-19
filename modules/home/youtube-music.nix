{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.atomazu.youtube-music;
  configDir = ".config/YouTube Music";
in
{
  options.atomazu.youtube-music = {
    enable = lib.mkEnableOption "YouTube Music desktop application";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.youtube-music;
      description = "YouTube Music package to use";
    };

    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "YouTube Music configuration";
      example = lib.literalExpression ''
        {
          options = {
            startAtLogin = true;
            themes = [ "/path/to/custom-theme.css" ];
          };
          plugins = {
            discord.enabled = false;
            "ad-blocker".enabled = true;
          };
        }
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ cfg.package ];

    home.file."${configDir}/config.json" = lib.mkIf (cfg.settings != { }) {
      force = true;
      text = pkgs.lib.generators.toJSON { } cfg.settings;
    };

    home.activation.youtubeMusicSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      $DRY_RUN_CMD mkdir -p "$HOME/${configDir}"
      CONFIG_PATH="$HOME/${configDir}/config.json"
      if [ -L "$CONFIG_PATH" ]; then
        $DRY_RUN_CMD cp -f "$(readlink -f "$CONFIG_PATH")" "$CONFIG_PATH.tmp"
        $DRY_RUN_CMD mv "$CONFIG_PATH.tmp" "$CONFIG_PATH"
      fi
      $DRY_RUN_CMD chmod -R u+w "$HOME/${configDir}"
    '';
  };
}
