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
    # == PLANNED == (This should be display server agnostic)
    # display = [
    #   {
    #     output = "DP-2";
    #     resolution = "2560x1440@240";
    #     primary = true;
    #   }
    #   {
    #     output = "HDMI-0";
    #     resolution = "2560x1440@140";
    #     rotate = "left";
    #   }
    # ];
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

  # profiles.cinnamon.enable = true;
  profiles.hyprland.enable = true;

  ### Custom Tweaks ###

  # Fish enables this, but it's too slow.. Overwritten!
  documentation.man.generateCaches = false;

  # For nix dev flakes
  programs.direnv.enable = true;

  # services.xserver.enable = true;
  # services.xserver.excludePackages = with pkgs; [ xterm ];
  # services.xserver.xrandrHeads = [
  #   {
  #     output = "HDMI-0";
  #     monitorConfig = "Option \"Rotate\" \"left\"";
  #   }
  #   {
  #     output = "DP-2";
  #     primary = true;
  #   }
  # ];

  # environment.systemPackages = with pkgs; [
  #   xclip
  #   calibre
  # ];

  home-manager.users.${config.sys.user} = {
    # ...
  };
}
