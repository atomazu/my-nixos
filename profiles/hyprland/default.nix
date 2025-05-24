{
  config,
  lib,
  ...
}:

let
  cfg = config.profiles.hyprland;
in
{
  ### Options ###

  options.profiles.hyprland = {
    enable = lib.mkEnableOption "Hyprland profile";
    launcher = lib.mkOption {
      type = lib.types.string;
      default = "albert";
      description = "App launcher, supports: 'albert'";
    };
    terminal = lib.mkOption {
      type = lib.types.string;
      default = "kitty";
      description = "Terminal emulator, supports: 'kitty'";
    };
    # I plan on adding options for waybar, mako etc.
  };

  ### Configuration ###

  config = lib.mkIf (cfg.enable) {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    home-manager.users.${config.sys.user} = {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          exec-once = [
            "albert"
          ];

          "$mod" = "SUPER";

          bind = [
            # Window Control
            "$mod, Q, killactive"
            "$mod, F, fullscreen, 0"
            "$mod, T, togglefloating"

            # Window Focus
            "$mod, H, movefocus, l"
            "$mod, J, movefocus, d"
            "$mod, K, movefocus, u"
            "$mod, L, movefocus, r"

            # Window Movement
            "$mod SHIFT, H, movewindow, l"
            "$mod SHIFT, J, movewindow, d"
            "$mod SHIFT, K, movewindow, u"
            "$mod SHIFT, L, movewindow, r"

            # Apps
            "$mod, RETURN, exec, kitty"
            "$mod, SPACE, exec, albert toggle"
            "$mod, B, exec, chromium"
          ];

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          windowrule = [
            "noborder, title:Albert"
            "noblur, title:Albert"
            "noshadow, title:Albert"
          ];
        };
      };
    };
  };
}
