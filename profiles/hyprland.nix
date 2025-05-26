{ config, lib, ... }:

let
  cfg = config.profiles;
in
{
  # imports = [];

  ### Options ###

  options.profiles.hyprland = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Hyprland compositor/window-manager.";
    };
  };

  ### Configuration ###

  # config = {};
}
