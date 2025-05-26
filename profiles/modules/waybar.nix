{ config, ... }:

{
  home-manager.users.${config.sys.user}.programs.waybar = {
    style = ''
      *{
        font-size: 12px;
        color: rgba(255, 255, 255, 1.0);
      }

      window#waybar {
        background: rgba(0, 0, 0, 0.5);
      }

      #workspaces button {
        padding: 0 6px;
        margin: 0 2px;
        background: none;
        border: none;
        border-radius: 4px;
      }

      #workspaces button.active {
        background: rgba(255, 255, 255, 0.1);
      }

      #workspaces button:hover {
        background: rgba(255, 255, 255, 0.05);
      }

      #backlight,
      #battery,
      #clock,
      #cpu,
      #memory,
      #tray,
      #pulseaudio {
        margin: 0 9px;
        background: none;
      }
    '';

    settings = {
      mainBar = {
        height = 24;
        spacing = 8;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
        ];
        modules-center = [
          "sway/window"
        ];
        modules-right = [
          "pulseaudio"
          "cpu"
          "memory"
          "sway/language"
          "clock"
          "tray"
        ];
        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };
        "sway/scratchpad" = {
          format = "{icon} {count}";
          "show-empty" = false;
          "format-icons" = [
            ""
            ""
          ];
          tooltip = true;
          "tooltip-format" = "{app}: {title}";
        };
        tray = {
          spacing = 10;
        };
        clock = {
          "tooltip-format" = "<big>{:%Y %B}</big>\\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          "format-muted" = "";
          "format-icons" = {
            headphone = "";
            "hands-free" = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };
      };
    };
  };
}
