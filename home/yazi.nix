{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home.yazi;
in
{
  options.atomazu.my-nixos.home.yazi = {
    enable = lib.mkEnableOption "Blazing Fast Terminal File Manager";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.atomazu.my-nixos.host.user} = {
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
