{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./..
    ./hardware.nix
  ];

  ### Settings ###

  host = {
    name = "desktop";
    user = "jonas";
    locale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";
    layout = "us";

    stylix = {
      scheme = "tomorrow-night";
    };
  };

  sys = {
    gpu.nvidia.enable = true;
    boot = {
      loader.grub = {
        enable = true;
        res = "2560x1440";
        prober = true;
      };
      silent = true;
      plymouth = true;
    };
  };

  home = {
    git = {
      enable = true;
      name = "atomazu";
      email = "contact@atomazu.org";
      signing = {
        enable = true;
        format = "ssh";
      };
    };
    shell.enable = true;
    chromium.enable = true;
    albert.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    ashell = {
      enable = true;
      swayncIntegration = true;
    };
  };

  profiles.hyprland =
    let
      displays = [
        "DP-2, 2560x1440@240, 1440x560, 1"
        "HDMI-A-1, 2560x1440@140, 0x0, 1, transform, 1"
      ];
    in
    {
      enable = true;
      albert = {
        enable = true;
        keybind = "$mod, R";
      };
      settings = {
        monitor = displays;

        bind = [
          "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
          "$mod, B, exec, ${pkgs.chromium}/bin/chromium"

          # Monitor-column traversal
          "$mod CTRL, E, workspace, +1"
          "$mod CTRL, Q, workspace, -1"
          "$mod SHIFT, E, movetoworkspace, +1"
          "$mod SHIFT, Q, movetoworkspace, -1"
        ];

        workspace = [
          # DP-1: Vertical Monitor
          "1, monitor:HDMI-A-1, default:true, defaultName:1-1"
          "2, monitor:HDMI-A-1, defaultName:1-2"
          "3, monitor:HDMI-A-1, defaultName:1-3"
          "4, monitor:HDMI-A-1, defaultName:1-4"
          "5, monitor:HDMI-A-1, defaultName:1-5"

          # DP-3: Main Monitor (240Hz)
          "6, monitor:DP-2, default:true, defaultName:2-1"
          "7, monitor:DP-2, defaultName:2-2"
          "8, monitor:DP-2, defaultName:2-3"
          "9, monitor:DP-2, defaultName:2-4"
          "10, monitor:DP-2, defaultName:2-5"
        ];

        exec-once = [
          "${inputs.ashell.defaultPackage.${pkgs.system}}/bin/ashell"
          "/run/current-system/sw/bin/fcitx5" # Not pkg path, needs to be in current environment
          "${pkgs.hyprland}/bin/hyprctl dispatch workspace 6" # Put mouse on main monitor at startup
        ];
      };
    };

  ### Custom Tweaks ###

  # Fish enables this, but it's slow..
  # Investigate: There seems to be an option in fish's home manager module to disable this
  documentation.man.generateCaches = false;

  services.displayManager.gdm.autoSuspend = false;
  services.displayManager.gdm.enable = true;

  # # Steam
  # programs.steam.enable = true;
  # hardware.steam-hardware.enable = true;
  # programs.steam.extest.enable = true;
  # programs.steam.remotePlay.openFirewall = true;
  # programs.steam.localNetworkGameTransfers.openFirewall = true;
  # programs.gamescope.enable = true;
  # programs.steam.dedicatedServer.openFirewall = true;

  environment.systemPackages = with pkgs; [
    anki-bin
    mpv
    libnotify
  ];

  environment.sessionVariables = {
    "ANKI_WAYLAND" = "1";
  };

  home-manager.users.${config.host.user} = {
    # programs.vesktop.enable = true;

    services.swaync.enable = true;
    services.swaync.settings = {
      control-center-margin-top = 8;
      control-center-margin-bottom = 8;
      control-center-margin-right = 8;
      control-center-margin-left = 8;
      control-center-width = 500;
      control-center-height = 600;
      positionX = "right";
      positionY = "bottom";
    };
  };
}
