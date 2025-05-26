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
  };

  profiles.cinnamon.enable = true;

  ### Custom Tweaks ###

  users.users.${config.sys.user}.shell = pkgs.fish;

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

  # environment.systemPackages = with pkgs; [];

  programs.fish.enable = true;
  home-manager.users.${config.sys.user} =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        tree
        gh
        xclip
        eza
        bat
        ripgrep
        fd
      ];

      programs.kitty = {
        enable = true;
        shellIntegration.enableFishIntegration = true;
        environment = {
          "EDITOR" = "nvim";
        };
      };

      programs.zoxide = {
        enable = true;
        enableFishIntegration = true;
      };

      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        defaultOptions = [
          "--height 40%"
          "--layout=reverse"
          "--border"
        ];
      };

      programs.starship.enable = true;
      programs.fish = {
        enable = true;
        shellAliases = {
          ls = "eza";
          l = "eza -l";
          la = "eza -la";
          ll = "eza -lghH --git";
          cat = "bat";
          grep = "rg";
          find = "fd";
          tree = "eza --tree";
        };
      };
    };
}
