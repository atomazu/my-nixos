{ config, lib, pkgs, ... }:

let 
  cfg = config.profiles;
in
{
  # imports = [];

  ### Options ###

  options.profiles.gnome = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Gnome profile.";
    };
  };

  ### Configuration ###

  config = (lib.mkIf (cfg.gnome.enable) ({
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.gnome.core-utilities.enable = false;
    
    home-manager.users.${config.sys.user} = lib.mkMerge [
      # ...
    ];
  }));
}
