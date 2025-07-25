{
  atomazu,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.atomazu.youtube-music;
  source = pkgs.writeText "yt-music-config.json" (pkgs.lib.generators.toJSON { } cfg.settings);
  target = ".config/YouTube Music/config.json";
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
    home.activation.youtubeMusicSettings = atomazu.lib.mkWritable source target;
  };
}
