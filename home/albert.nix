{
  pkgs,
  lib,
  config,
  ...
}:
let
  albertConfigAttrs = {
    General = {
      telemetry = false;
    };

    applications = {
      enabled = true;
    };

    calculator_qalculate = {
      enabled = true;
    };

    chromium = {
      enabled = true;
    };

    clipboard = {
      enabled = true;
    };

    debug = {
      enabled = false;
    };

    docs = {
      enabled = false;
    };

    python = {
      enabled = false;
    };

    system = {
      enabled = true;
    };

    websearch = {
      enabled = true;
    };

    widgetsboxmodel = {
      alwaysOnTop = true;
      clearOnHide = false;
      clientShadow = true;
      darkTheme = "CUSTOM";
      displayScrollbar = false;
      followCursor = true;
      hideOnFocusLoss = true;
      historySearch = true;
      itemCount = 5;
      lightTheme = "CUSTOM";
      quitOnClose = false;
      showCentered = true;
      systemShadow = true;
    };
  };

  iniText = lib.generators.toINI { } albertConfigAttrs;

  themeTargetPath = "${config.xdg.dataHome}/albert/widgetsboxmodel/themes/CUSTOM.qss";
  themeSourceFile = ./src/albert_style.qss;
in
{
  home.packages = [ pkgs.albert ];

  home.activation = {
    copyAlbertTheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      target="${themeTargetPath}"
      source="${themeSourceFile}"
      targetDir="$(${pkgs.coreutils}/bin/dirname "$target")"
      ${pkgs.coreutils}/bin/mkdir -p "$targetDir"
      ${pkgs.coreutils}/bin/cp -f "$source" "$target"
    '';
  };

  systemd.user.services.albert = {
    Unit = {
      Description = "Albert Launcher";
      # Documentation = "https://albertlauncher.github.io/"; # Optional documentation link
      # Ensure the graphical session is available before starting
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ]; # Tie lifecycle to graphical session
    };

    Service = {
      # The command to start Albert
      ExecStart = "${pkgs.albert}/bin/albert";

      # Optional: Restart Albert if it crashes
      Restart = "on-failure";
      RestartSec = 5; # Wait 5 seconds before restarting
    };

    Install = {
      # Tell systemd to start this service as part of the graphical user session
      WantedBy = [ "graphical-session.target" ];
    };
  };

  xdg.configFile = {
    "albert/config" = {
      text = iniText;
    };
  };
}
