{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.home.vim;
in
{
  options.home.vim = {
    enable = lib.mkEnableOption "Enable legacy Vim.";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.sys.user}.programs.vim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        vim-airline
        nerdtree
        vim-fugitive
        vim-nix
        syntastic
        vim-commentary
        auto-pairs
      ];

      settings = {
        number = true;
        tabstop = 2;
        relativenumber = true;
        shiftwidth = 2;
        expandtab = true;
      };

      extraConfig = ''
        set nocompatible
        filetype plugin indent on
        let NERDTreeShowHidden=1
        syntax on

        map <C-n> :NERDTreeToggle<CR>
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        inoremap jj <esc>
      '';
    };
  };
}
