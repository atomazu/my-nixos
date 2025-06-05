{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.home.yazi;
in
{
  options.home.yazi = {
    enable = lib.mkEnableOption "Enable yazi file manager";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.host.user} = {
      programs.yazi = {
        enable = true;
        enableFishIntegration = true;
        settings = {
          manager = {
            show_hidden = true;
          };
        };
        keymap = {
          mgr.prepend_keymap = [
            {
              on = "<C-y>";
              run = [ "plugin wl-clipboard" ];
            }
          ];
        };
        plugins = {
          system-clipboard = pkgs.fetchFromGitHub {
            owner = "grappas";
            repo = "wl-clipboard.yazi";
            rev = "master";
            sha256 = "sha256-jlZgN93HjfK+7H27Ifk7fs0jJaIdnOyY1wKxHz1wX2c=";
          };
        };
      };
    };
  };
}
