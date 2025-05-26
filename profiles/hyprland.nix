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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Hyprland profile. (planned)";
    };
  };

  ### Configuration ###

  config = {
    home-manager.users.${config.sys.user} = lib.mkMerge [
      # ...
    ];
  };
}
