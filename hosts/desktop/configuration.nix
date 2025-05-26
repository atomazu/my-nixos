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
    chromium.enable = true;
    albert.enable = false;
    nixvim.enable = true;
    tmux.enable = true;
  };

  profiles.cinnamon.enable = true;

  ### Custom Tweaks ###

  environment.sessionVariables = {
    FLAKE = "/home/jonas/.nixos";
  };

  services.xserver.enable = true;
  services.xserver.excludePackages = with pkgs; [ xterm ];
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
    tree
    gh
    xclip
  ];

  home-manager.users.${config.sys.user} = {
    # ...
  };
}
