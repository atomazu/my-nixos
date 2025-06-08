{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.profiles.hyprland;
  polkitSettings = {
    exec-once = [
      "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
    ];
  };

  albertSettings = {
    exec-once = [
      "/run/current-system/sw/bin/albert"
    ];

    windowrule = [
      "noborder, title:Albert"
      "noblur, title:Albert"
      "noshadow, title:Albert"
    ];

    bind = [
      "$mod, SPACE, exec, /run/current-system/sw/bin/albert toggle"
    ];
  };

  osdSettings = {
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

  bindingSettings = import ./bindings.nix;

  playerctlSettings = {
    bindl = [
      ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
      ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
      ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
      ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
    ];
  };

  screenshotSettings = {
    bind = [
      "$mod SHIFT, S, exec, ${pkgs.grim}/bin/grim -g \"$(${pkgs.slurp}/bin/slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy"
    ];
  };

  globalSettings = {
    "$mod" = cfg.mod;
  };

  visualSettings = {
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
    globalSettings
    visualSettings
    bindingSettings
    screenshotSettings
    (lib.mkIf cfg.albertIntegration albertSettings)
    (lib.mkIf cfg.playerctl playerctlSettings)
    (lib.mkIf cfg.polkit polkitSettings)
    (lib.mkIf cfg.osd osdSettings)
  ]
)
