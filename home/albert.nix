{
  pkgs,
  config,
  lib,
  ...
}:

{
  environment.systemPackages = with pkgs; [ albert ];

  home-manager.users.${config.sys.user} = lib.mkIf (config.home.albert == true) {
    home.file.".local/share/albert/widgetsboxmodel/themes/custom_theme.qss".source =
      ./src/albert_style.qss;
  };
}
