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
    stylix = {
      enable = true;
      base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night.yaml";
    };
  };

  sys = {
    gpu = "nvidia";
    locale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";
    layout = "us";
    time = "Europe/Berlin";

    boot = {
      loader.grub.enable = true;
      resolution = "2560x1440";
      prober = true;
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
    shell = {
      enable = true;
      font-size = 16;
    };
    chromium.enable = true;
    albert.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
    ashell.enable = true;
  };

  profiles.hyprland = {
    enable = true;
    albertIntegration = true;
    extraSettings = {
      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, B, exec, ${pkgs.chromium}/bin/chromium"

        # Monitor-column traversal
        "$mod CTRL, E, workspace, +1"
        "$mod CTRL, Q, workspace, -1"
        "$mod SHIFT, E, movetoworkspace, +1"
        "$mod SHIFT, Q, movetoworkspace, -1"
      ];

      monitor = [
        "DP-2, 2560x1440@240, 1440x560, 1"
        "HDMI-A-1, 2560x1440@140, 0x0, 1, transform, 1"
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
      ];
    };
  };

  ### Custom Tweaks ###

  # Fish enables this, but it's too slow..
  # documentation.man.generateCaches = false;

  # For nix dev flakes
  programs.direnv.enable = true;

  # Never hurts to be enabled
  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [ xterm ];
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.xrandrHeads = [
    {
      output = "HDMI-0";
      monitorConfig = "Option \"Rotate\" \"left\"";
    }
    {
      output = "DP-2";
      primary = true;
    }
  ];

  # For ashell (doesn't make that much sense for a desktop)
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [
    # Neovim needs this for unnamedplus
    wl-clipboard

    man-pages
    man-pages-posix

    # For ashell and hyprland binds
    brightnessctl
    nm-tray
    blueman
  ];

  home-manager.users.${config.host.user} = {
    # ...
  };
}
