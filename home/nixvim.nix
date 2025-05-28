{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.home.nixvim;
in
{
  options.home.nixvim = {
    enable = lib.mkEnableOption "Nixvim config for Neovim";
  };

  config = lib.mkIf (cfg.enable) {
    home-manager.users.${config.sys.user} = {
      imports = [
        inputs.nixvim.homeManagerModules.nixvim
      ];

      programs.nixvim = {
        enable = true;

        globals.mapleader = " ";

        extraPackages = with pkgs; [
          nixfmt-rfc-style
          git
          ripgrep
          fd
          fzf
          gcc
        ];

        opts = {
          number = true;
          relativenumber = true;
          cursorline = true;
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
          scrolloff = 12;
          sidescrolloff = 8;
          ignorecase = true;
          smartcase = true;
          autoindent = true;
          timeout = true;
          timeoutlen = 50;
        };

        clipboard.register = "unnamedplus";

        viAlias = true;
        vimAlias = true;

        plugins = {
          lazy.enable = true;

          # CMP
          cmp = {
            enable = true;
            settings = {
              sources = [
                { name = "nvim_lsp"; }
                { name = "path"; }
                { name = "buffer"; }
              ];
              mapping = {
                "<C-Space>" = "cmp.mapping.complete()";
                "<C-d>" = "cmp.mapping.scroll_docs(-4)";
                "<C-e>" = "cmp.mapping.close()";
                "<C-f>" = "cmp.mapping.scroll_docs(4)";
                "<CR>" = "cmp.mapping.confirm({ select = true })";
                "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
                "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              };
            };
          };

          # LSP
          lsp-format.enable = true;
          lsp-signature.enable = true;
          lsp-status.enable = true;

          # For hover doc
          lspsaga.enable = true;

          lsp = {
            enable = true;
            servers = {
              bashls.enable = true;
              clangd.enable = true;
              nixd.enable = true;
              pyright.enable = true;
              gopls.enable = true;
              asm_lsp.enable = true;
            };
          };

          # Generates minimal diffs for formatting changes
          conform-nvim.enable = true;

          # Visual
          lualine.enable = true;
          web-devicons.enable = true;
          notify.enable = true;
          dashboard.enable = true;
          # dressing.enable = true;
          gitsigns.enable = true;

          # Utillity
          # flash.enable = true;
          treesitter.enable = true;
          comment.enable = true;
          # fugitive.enable = true;
          nvim-autopairs.enable = true;
          nvim-surround.enable = true;
          which-key.enable = true;

          toggleterm = {
            enable = true;
            settings = {
              insert_mappings = false;
              open_mapping = "[[<leader>t]]";
            };
          };

          # Oil
          oil-git-status.enable = true;
          oil = {
            enable = true;
            settings = {
              view_options = {
                show_hidden = true;
              };
              win_options = {
                signcolumn = "yes:2";
              };
            };
          };

          # Telescope
          telescope = {
            enable = true;
            extensions.fzf-native.enable = true;
          };

          nix.enable = true;
        };
      };
    };
  };
}
