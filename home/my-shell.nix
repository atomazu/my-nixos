{
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home.my-shell;
  colors = config.lib.stylix.colors.withHashtag;
  fonts = config.stylix.fonts;
in
{
  options.atomazu.my-nixos.home.my-shell = {
    enable = lib.mkEnableOption "atomazu's desktop shell with opinionated settings";
    settings = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Settings to be merged into default";
    };
  };

  config.home-manager.users.${config.atomazu.my-nixos.host.user} = lib.mkIf (cfg.enable) {
    atomazu.my-shell = {
      enable = true;
      settings = lib.recursiveUpdate {
        theme = {
          font = {
            size = fonts.sizes.applications;
            family = fonts.sansSerif.name;
          };

          color00 = colors.base00;
          color01 = colors.base01;
          color02 = colors.base02;
          color03 = colors.base03;
          color04 = colors.base04;
          color05 = colors.base05;
          color06 = colors.base06;
          color07 = colors.base07;
          color08 = colors.base08;
          color09 = colors.base09;
          color0A = colors.base0A;
          color0B = colors.base0B;
          color0C = colors.base0C;
          color0D = colors.base0D;
          color0E = colors.base0E;
          color0F = colors.base0F;
        };
      } cfg.settings;
    };
  };
}
