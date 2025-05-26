{
  config,
  lib,
  ...
}:

let
  cfg = config.profiles.hyprland;
in
{
  ### Options ###

  options.profiles.hyprland = {
    enable = lib.mkEnableOption "Hyprland profile";
  };

  ### Configuration ###

  config = lib.mkIf (cfg.enable) {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
    };
    home-manager.users.${config.sys.user} = {
      wayland.windowManager.hyprland = {
        enable = true;
      };
    };
  };
}
