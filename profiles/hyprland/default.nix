{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.profiles.hyprland;
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
  # waybarSettings = {
  #   exec-once = [
  #     "${pkgs.waybar}/bin/waybar"
  #   ];
  # };
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
    # So apps can ask for permission
    environment.systemPackages = [ pkgs.hyprpolkitagent ];

    # For screensharing
    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
    };

    # To prevent Electron applications defaulting to X11
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Enable Hyprland with UWSM
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };

    home-manager.users.${config.sys.user} = {
      wayland.windowManager.hyprland = {
        enable = true;

        # Disable systemd integration as it conflicts with UWSM
        systemd.enable = false;
        systemd.variables = [ "--all" ];

        # Hyprland settings
        settings = lib.mkMerge (
          [
            {
              decoration.blur.enabled = false;
              "$mod" = "SUPER";

              exec-once = [
                "${pkgs.hyprpolkitagent}/bin/hyprpolkitagent"
              ];

              bind =
                [
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
                ] # Generates binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
                ++ (builtins.concatLists (
                  builtins.genList (
                    i:
                    let
                      ws = i + 1;
                    in
                    [
                      "$mod, code:1${toString i}, workspace, ${toString ws}"
                      "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                    ]
                  ) 9
                ));

              bindm = [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
              ];
            }
            cfg.extraSettings
          ]
          ++ lib.optionals cfg.albertIntegration [ albertSettings ]
        );
      };
    };
  };
}
