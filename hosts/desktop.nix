{ inputs, pkgs, ... }:

{
  imports = [
    ./../hosts/default.nix
    ./hardware-desktop.nix

    inputs.home-manager.nixosModules.default
  ];

  ### System Settings ###

  sys.gpu = "nvidia";
  sys.host = "desktop";
  sys.user = "jonas";
  sys.locale = "en_US.UTF-8";
  sys.extraLocale = "de_DE.UTF-8";
  sys.layout = "us";
  sys.time = "Europe/Berlin";
  sys.boot = {
    loader = "grub";
    resolution = "2560x1440";
    prober = true;
    silent = true;
    plymouth = true;
  };

  ### Profile Settings ###

  profiles.cinnamon.enable = true;

  ### Custom Configuration ###

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
    alacritty
  ];
}
