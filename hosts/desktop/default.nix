{
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./..
    ./hardware.nix
    ./hyprland.nix
    ./blog.nix
  ];

  ### Settings ###

  host = {
    name = "desktop";
    user = "jonas";
    locale = "en_US.UTF-8";
    extraLocale = "de_DE.UTF-8";
    layout = "us";
    extras = {
      jp.enable = true;
    };

    stylix = {
      scheme = "tomorrow-night";
    };
  };

  sys = {
    gpu.nvidia.enable = true;
    displayManager.gdm.enable = true;
    boot = {
      loader.grub = {
        enable = true;
        prober = true;
        res = "2560x1440";
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

    chromium = {
      enable = true;
      widevine = true;
      extensions = {
        bitwarden = true;
        uBlockLite = true;
        darkReader = true;
        sponsorBlock = true;
        yomitan = true;
        malSync = true;
        vimium = true;
        websiteBlocker = true;
      };
    };

    shell = {
      enable = true;
    };

    albert.enable = true;
    nixvim.enable = true;
    tmux.enable = true;

    ashell = {
      enable = true;
      swayncIntegration = true;
    };
  };

  ### Additional Tweaks ###

  home-manager.users.${config.host.user} = {
    home.packages = with pkgs; [
      anki-bin
      youtube-music
    ];

    programs.vesktop.enable = true;
    programs.mpv.enable = true;
  };
}
