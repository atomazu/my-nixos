{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.atomazu.my-nixos.home.tmux;
in
{
  options.atomazu.my-nixos.home.tmux = {
    enable = lib.mkEnableOption "Tmux terminal multiplexer";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.atomazu.my-nixos.host.user}.programs.tmux = {
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
