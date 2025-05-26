{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.system;
in
{
  options.system.template = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the template system module.";
    };
    # Add more options specific to this module here
  };

  config = lib.mkIf (cfg.template.enable) {
    # System-level configuration goes here
  };
}