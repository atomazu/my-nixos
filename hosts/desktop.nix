{ inputs, pkgs, ...}:

{
  imports = [
    ./../system/default.nix
    ./../profiles/default.nix
    ./../hosts/default.nix

    inputs.home-manager.nixosModules.default
  ];

  ### System Settings ###

  sys.gpu = "nvidia";
  # sys.theme = "catppuccin";
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

  # ...

  ### Profile Settings ###

  profiles.gnome.enable = true;

  # ...

  ### Custom Configuration ###

  # ...

  services.xserver.enable = true;
  services.xserver.xrandrHeads = [
    {
      output = "DP-0";
      monitorConfig = "Option \"Rotate\" \"left\"";
    }
    {
      output = "DP-4";
      primary = true;
    }
  ];

  environment.systemPackages = with pkgs; [
    tree
    gh
    alacritty
    chromium
  ];

  # ...
}
