{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./../default.nix
    ./hardware-configuration.nix
  ];

  ### Settings ###

  sys = {
    gpu = "nvidia";
    host = "desktop";
    user = "jonas";
    locale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";
    layout = "us";
    time = "Europe/Berlin";
    boot = {
      loader = "grub";
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
    };
    shell = {
      enable = true;
      font-size = 16;
    };
    chromium.enable = true;
    albert.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
  };

  profiles.hyprland = {
    enable = true;
    albertIntegration = true;
    extraSettings = {
      bind = [
        "$mod, RETURN, exec, ${pkgs.kitty}/bin/kitty"
        "$mod, B, exec, ${pkgs.chromium}/bin/chromium"
      ];
      monitor = [
        "DP-2, 2560x1440@240, 1440x560, 1"
        "HDMI-A-1, 2560x1440@140, 0x0, 1, transform, 1"
      ];
    };
  };

  ### Custom Tweaks ###

  # Fish enables this, but it's too slow.. Overwritten!
  documentation.man.generateCaches = false;

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

  environment.systemPackages = with pkgs; [
    wl-clipboard
  ];

  home-manager.users.${config.sys.user} = {
    # ...
  };
}
