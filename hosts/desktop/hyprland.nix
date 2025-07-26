{
  config,
  pkgs,
  ...
}:

{
  atomazu.my-nixos.profiles.hyprland = {
    enable = true;

    osd.enable = true;
    launcher.enable = true; # default: mod+r
    hyprsunset.enable = true; # default: mod+n

    settings = {
      monitor = [
        "DP-2, 2560x1440@240, 1440x560, 1"
        "HDMI-A-1, 2560x1440@140, 0x0, 1, transform, 1"
      ];

      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, B, exec, ${config.atomazu.my-nixos.home.chromium.package}/bin/chromium"

        # Monitor-column traversal
        "$mod CTRL, E, workspace, +1"
        "$mod CTRL, Q, workspace, -1"
        "$mod SHIFT, E, movetoworkspace, +1"
        "$mod SHIFT, Q, movetoworkspace, -1"
      ];

      workspace = [
        # DP-1: Vertical Monitor (Acer)
        "1, monitor:HDMI-A-1, default:true, defaultName:1-1"
        "2, monitor:HDMI-A-1, defaultName:1-2"
        "3, monitor:HDMI-A-1, defaultName:1-3"
        "4, monitor:HDMI-A-1, defaultName:1-4"
        "5, monitor:HDMI-A-1, defaultName:1-5"

        # DP-3: Main Monitor (UltraGear)
        "6, monitor:DP-2, default:true, defaultName:2-1"
        "7, monitor:DP-2, defaultName:2-2"
        "8, monitor:DP-2, defaultName:2-3"
        "9, monitor:DP-2, defaultName:2-4"
        "10, monitor:DP-2, defaultName:2-5"
      ];

      exec-once = [ "${pkgs.hyprland}/bin/hyprctl dispatch workspace 6" ];

      input = {
        kb_options = "ctrl:nocaps";
      };
    };
  };
}
