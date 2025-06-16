{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.hyprland;
  polkit = {
    exec-once = [
      "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
    ];
  };

  albert = {
    exec-once = [
      "/run/current-system/sw/bin/albert"
    ];

    windowrule = [
      "noborder, title:Albert"
      "noblur, title:Albert"
      "noshadow, title:Albert"
    ];

    bind = [
      "${cfg.albert.keybind}, exec, /run/current-system/sw/bin/albert toggle"
    ];
  };

  osd = {
    exec-once = [
      "${pkgs.swayosd}/bin/swayosd-server"
    ];

    # Media & Hardware Controls
    bindel = [
      ", XF86AudioRaiseVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume raise --max-volume 100"
      ", XF86AudioLowerVolume, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume lower --max-volume 100"
      ", XF86AudioMute, exec, ${pkgs.swayosd}/bin/swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, ${pkgs.swayosd}/bin/swayosd-client --input-volume mute-toggle"
      ", XF86MonBrightnessUp, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, ${pkgs.swayosd}/bin/swayosd-client --brightness lower"
    ];
  };

  binding = import ./bindings.nix;

  playerctl = {
    bindl = [
      ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
    ];
  };

  screenshot = {
    bind = [
      "$mod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
    ];
  };

  global = {
    "$mod" = cfg.mod;
  };

  visual = {
    general = {
      gaps_in = 2;
      gaps_out = "3, 3, 3, 3";
      border_size = 2;
    };

    # Smart Gaps
    workspace = [
      "w[tv1], gapsout:0, gapsin:0"
      "f[1], gapsout:0, gapsin:0"
    ];

    # Smart border
    windowrule = [
      "bordersize 0, floating:0, onworkspace:w[tv1]"
      "rounding 0, floating:0, onworkspace:w[tv1]"
      "bordersize 0, floating:0, onworkspace:f[1]"
      "rounding 0, floating:0, onworkspace:f[1]"
    ];

    decoration = {
      rounding = 6;

      blur.enabled = false;
      shadow.enabled = false;
    };
  };
in
lib.recursiveUpdate { } (
  lib.mkMerge [
    global
    visual
    binding
    screenshot
    (lib.mkIf cfg.albert.enable albert)
    (lib.mkIf cfg.playerctl playerctl)
    (lib.mkIf cfg.polkit polkit)
    (lib.mkIf cfg.osd osd)
  ]
)
