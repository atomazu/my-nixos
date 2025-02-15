{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    # terminal = "tmux-256color";
    escapeTime = 10;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
    ];
  };
}
