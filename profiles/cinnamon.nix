{
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.profiles;
in
{
  ### Options ###

  options.atomazu.my-nixos.profiles.cinnamon = {
    enable = lib.mkEnableOption "Cinnamon profile";
  };

  ### Configuration ###

  config = (
    lib.mkIf (cfg.cinnamon.enable) {
      services.xserver.desktopManager.cinnamon.enable = true;
      services.cinnamon.apps.enable = false;

      home-manager.users.${config.atomazu.my-nixos.host.user} = {
        dconf.settings = {
          "org/cinnamon" = {
            panels-height = [ "1:40" ];
            panel-zone-symbolic-icon-sizes = "[{\"panelId\": 1, \"left\": 28, \"center\": 28, \"right\": 16}]";
          };

          "org/cinnamon/sounds" = {
            switch-enabled = false;
            tile-enabled = false;
          };

          "org/gnome/desktop/peripherals/mouse" = {
            accel-profile = "flat";
            speed = 0.2;
          };

          "org/gnome/desktop/interface" = {
            gtk-theme = "Mint-Y-Dark-Blue";
            icon-theme = "Mint-Y-Blue";
          };

          "org/cinnamon/desktop/background" = {
            picture-uri = "file://${../assets/binary.png}";
          };

          "org/cinnamon" = {
            panels-autohide = [ "1:true" ];
          };
        };
      };
    }
  );
}
