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
    # resolution = "2560x1440";
    prober = true;
    silent = true;
  };

  # ...

  ### Profile Settings ###

  profiles.hyprland.enable = true;

  # ...

  ### Custom Configuration ###

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };
  programs.uwsm.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r -i --cmd 'uwsm start -S -F /run/current-system/sw/bin/Hyprland'";
        user = "greeter";
      };
    };
  };

  # services.xserver.xrandrHeads = [
  #   {
  #     output = "DP-0";
  #     monitorConfig = "Option \"Rotate\" \"left\"";
  #   }
  #   {
  #     output = "DP-4";
  #     primary = true;
  #   }
  # ];

  environment.systemPackages = with pkgs; [
    tree
  ];

  # ...
}
