{
  config,
  lib,
  ...
}:

let
  cfg = config.profiles;
in
{
  ### Options ###

  options.profiles.hyprland = {
    enable = lib.mkEnableOption "Hyprland profile";
  };

  ### Configuration ###

  config = {
    home-manager.users.${config.sys.user} = lib.mkIf (cfg.hyprland.enable) {
      # ...
    };
  };
}
