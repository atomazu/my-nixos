{
  config,
  lib,
  ...
}:

let
  cfg = config.profiles;
in
{
  options.profiles.template = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the template profile.";
    };
  };

  config = lib.mkIf (cfg.template.enable) {
    # Configuration specific to this profile goes here
  };
}
