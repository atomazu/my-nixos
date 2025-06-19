{
  config,
  pkgs,
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
    boot = {
      loader.systemd.enable = true;
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
    nixvim.enable = true;
    tmux.enable = true;
    yazi.enable = true;
  };

  profiles.sway.enable = true;

  ### Custom Tweaks ###
  documentation.man.generateCaches = false;

  services.displayManager.gdm.autoSuspend = false;
  services.displayManager.gdm.enable = true;

  environment.systemPackages = with pkgs; [
    libnotify
  ];

  home-manager.users.${config.host.user} = {
    # ...
  };
}
