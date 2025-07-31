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
    {
      from,
      to,
      after ? "writeBoundary",
      also ? "",
    }:
    home.lib.hm.dag.entryAfter [ after ] ''
      TARGET="$HOME/${to}"
      TARGET_DIR="$(dirname "$TARGET")"

      run mkdir -p "$TARGET_DIR"
      run rm -rf "$TARGET"

      if [ -d "${from}" ]; then
        run cp -rT "${from}" "$TARGET"
      else 
        run cp "${from}" "$TARGET"
      fi

      run chmod -R u+w "$TARGET"
      ${also}
    '';
}
