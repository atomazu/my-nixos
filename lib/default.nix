{ home, nix }:
{
  mkEnableOption =
    description: default:
    nix.lib.mkOption {
      type = nix.lib.types.bool;
      default = default;
      example = !default;
      description = "Whether to enable ${description}";
    };

  mkAutoStart =
    {
      name,
      exec,
      env,
    }:
    {
      Unit = {
        Description = name;
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = exec;
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
        EnvironmentFile = nix.lib.mkIf (env != null) env;
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

  mkWritable =
    src: path:
    home.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      TARGET="$HOME/${path}"
      TARGET_DIR="$(dirname "$TARGET")"

      $DRY_RUN_CMD mkdir -p "$TARGET_DIR"

      if [ -d "${src}" ]; then
        $DRY_RUN_CMD cp -rf ${src}/* "$TARGET/"
      else
        if [ -L "$TARGET" ]; then
          $DRY_RUN_CMD cp -f "$(readlink -f "$TARGET")" "$TARGET.tmp"
          $DRY_RUN_CMD mv "$TARGET.tmp" "$TARGET"
        else
          $DRY_RUN_CMD cp -f ${src} "$TARGET"
        fi
      fi

      $DRY_RUN_CMD chmod -R u+w "$TARGET"
    '';
}
