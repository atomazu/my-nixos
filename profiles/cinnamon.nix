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

  options.profiles.cinnamon = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable the Cinnamon profile.";
    };
  };

  ### Configuration ###

  config = (
    lib.mkIf (cfg.cinnamon.enable) ({
      services.xserver.desktopManager.cinnamon.enable = true;

      home-manager.users.${config.sys.user} = lib.mkMerge [
        {
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
              speed = 0.36554621848739499;
            };

            "org/gnome/desktop/interface" = {
              gtk-theme = "Mint-Y-Dark-Blue";
              icon-theme = "Mint-Y-Blue";
            };

            "org/cinnamon/desktop/background" = {
              picture-uri = "file://${../assets/binary.png}";
            };
          };
        }
      ];
    })
  );
}
