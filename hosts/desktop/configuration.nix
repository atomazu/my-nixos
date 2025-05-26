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
    albert.enable = true;
    nixvim.enable = true;
    tmux.enable = true;
    shell.enable = true;
  };

  profiles.cinnamon.enable = true;

  ### Custom Tweaks ###

  environment.sessionVariables = {
    FLAKE = "/home/${config.sys.user}/.nixos";
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

  environment.systemPackages = with pkgs; [ xclip ];

  home-manager.users.${config.sys.user} = {
    # ...
  };
}
