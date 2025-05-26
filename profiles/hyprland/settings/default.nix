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
      "${pkgs.albert}/bin/albert"
    ];

    windowrule = [
      "noborder, title:Albert"
      "noblur, title:Albert"
      "noshadow, title:Albert"
    ];

    bind = [
      "$mod, SPACE, exec, ${pkgs.albert}/bin/albert toggle"
    ];
  };

  osdSettings = {
    exec-once = [
      "${pkgs.swayosd}/bin/swayosd-server"
    ];

    # Media & Hardware Controls
    bindel = [
      ", XF86AudioRaiseVolume, exec, swayosd-client --output-volume raise --max-volume 100"
      ", XF86AudioLowerVolume, exec, swayosd-client --output-volume lower --max-volume 100"
      ", XF86AudioMute, exec, swayosd-client --output-volume mute-toggle"
      ", XF86AudioMicMute, exec, swayosd-client --input-volume mute-toggle"
      ", XF86MonBrightnessUp, exec, swayosd-client --brightness raise"
      ", XF86MonBrightnessDown, exec, swayosd-client --brightness lower"
    ];
  };

  bindingSettings = import ./bindings.nix;

  playerctlSettings = {
    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPause, exec, playerctl play-pause"
    ];
  };
in
{
  "$mod" = cfg.mod;
  binding = bindingSettings;
  albert = lib.mkIf cfg.albertIntegration albertSettings;
  playerctl = lib.mkIf cfg.playerctl playerctlSettings;
  polkit = lib.mkIf cfg.polkit polkitSettings;
  osd = lib.mkIf cfg.osd osdSettings;
}
