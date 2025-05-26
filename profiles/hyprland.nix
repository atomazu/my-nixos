{ config, lib, pkgs, ... }:

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
      description = "Enable the Hyprland profile. (BROKEN!)";
    };
  };

  ### Configuration ###

  config = {
    home-manager.users.${config.sys.user} = lib.mkMerge [
#      (lib.mkIf (cfg.hyprland.enable) {
#          programs.hyprland = {
#	    enable = true;
#	    withUWSM = true;
#	  };
#	  programs.uwsm.enable = true;
#
#	  services.greetd = {
#	    enable = true;
#	    settings = {
#	      default_session = {
#		command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r -i --cmd 'uwsm start -S -F /run/current-system/sw/bin/Hyprland'";
#		user = "greeter";
#	      };
#	    };
#	  };
    ];
  };
}
