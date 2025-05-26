{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.home.tmux;
in
{
  options.home.tmux = {
    enable = lib.mkEnableOption "Tmux terminal multiplexer";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.sys.user}.programs.tmux = {
      enable = true;
      clock24 = true;
      escapeTime = 10;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
      ];
    };
  };
}
