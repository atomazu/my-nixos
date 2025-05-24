{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.hyprland;
  albertOverride = {
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
in
{
  ### Options ###

  options.profiles.hyprland = {
    enable = lib.mkEnableOption "Hyprland profile";
    extraSettings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Extra settings, will be merged with defaults";
    };
    albertIntegration = lib.mkEnableOption "Enable Albert integration";
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
        settings = lib.mkMerge (
          [
            {
              decoration.blur.enabled = false;
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
              ];

              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
              ];

              windowrule = [ ];
              exec-once = [ ];

            }
            cfg.extraSettings
          ]
          ++ lib.optionals cfg.albertIntegration [ albertOverride ]
        );
      };
    };
  };
}
