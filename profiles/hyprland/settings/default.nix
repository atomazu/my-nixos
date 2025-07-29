{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.atomazu.my-nixos.profiles.hyprland;
  polkit = {
    exec-once = [
      "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
    ];
  };

  launcher = {
    windowrule = cfg.launcher.windowRules;

    bind = [
      "${cfg.launcher.keybind}, exec, ${cfg.launcher.command}"
    ];
  };

  osd = {
    exec-once = [
      cfg.osd.serverCmd
    ];

    # Media & Hardware Controls
    bindel = [
      ", XF86AudioRaiseVolume, exec, ${cfg.osd.commands.volumeRaise}"
      ", XF86AudioLowerVolume, exec, ${cfg.osd.commands.volumeLower}"
      ", XF86AudioMute, exec, ${cfg.osd.commands.volumeToggle}"
      ", XF86AudioMicMute, exec, ${cfg.osd.commands.micToggle}"
      ", XF86MonBrightnessUp, exec, ${cfg.osd.commands.brightnessUp}"
      ", XF86MonBrightnessDown, exec, ${cfg.osd.commands.brightnessDown}"
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

  hyprsunset = {
    bind = [
      "${cfg.hyprsunset.keybind}, exec, ${pkgs.writeShellScript "toggle-hyprsunset" ''
        if pgrep -x "hyprsunset" > /dev/null; then
            pkill hyprsunset
            echo "Stopped hyprsunset"
        else
            ${pkgs.hyprsunset}/bin/hyprsunset -g ${toString cfg.hyprsunset.gamma} -t ${toString cfg.hyprsunset.temperature} &
            echo "Started hyprsunset"
        fi
      ''}"
    ];
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
    (lib.mkIf cfg.launcher.enable launcher)
    (lib.mkIf cfg.hyprsunset.enable hyprsunset)
    (lib.mkIf cfg.playerctl.enable playerctl)
    (lib.mkIf cfg.polkit.enable polkit)
    (lib.mkIf cfg.osd.enable osd)
  ]
)
