{
  config,
  lib,
  pkgs,
  atmzInputs,
  ...
}:
let
  cfg = config.atomazu.nixvim;
in
{
  options.atomazu.nixvim = {
    enable = lib.mkEnableOption "Nixvim config for Neovim";
  };

  imports = [
    atmzInputs.nixvim.homeManagerModules.nixvim
  ];

  config = lib.mkIf cfg.enable {
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
        lazygit
        wl-clipboard
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
      };

      clipboard.register = "unnamedplus";

      viAlias = true;
      vimAlias = true;

      plugins = {
        lazy.enable = true;
        lazygit.enable = true;

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

        lsp-format.enable = true;
        lsp-signature.enable = true;
        lsp-status.enable = true;

        # For hover doc and breadcrumbs...
        lspsaga.enable = true;

        # Web dev
        luasnip.enable = true;
        emmet.enable = true;

        lsp = {
          enable = true;
          servers = {
            bashls.enable = true;
            clangd.enable = true;
            nixd.enable = true;
            pyright.enable = true;
            gopls.enable = true;
            asm_lsp.enable = true;
            ts_ls.enable = true;
            eslint.enable = true;
            jsonls.enable = true;
            html.enable = true;
            cssls.enable = true;
          };
        };

        mini = {
          enable = true;
          mockDevIcons = true;
          modules = {
            move = {
              # Alt+hjkl move selection
              mappings = {
                left = "<M-h>";
                right = "<M-l>";
                down = "<M-j>";
                up = "<M-k>";

                line_left = "<M-h>";
                line_right = "<M-l>";
                line_down = "<M-j>";
                line_up = "<M-k>";
              };
            };
            # Needed for mockDevIcons
            icons = { };
          };
        };

        # Generates minimal diffs for formatting changes
        conform-nvim.enable = true;

        # Visual
        lualine.enable = true;
        gitsigns.enable = true;
        snacks = {
          enable = true;
          settings = {
            notifier = {
              enabled = true;
            };
            lazygit = {
              enabled = true;
            };
          };
        };

        # Utillity
        treesitter.enable = true;
        dashboard.enable = true;
        comment.enable = true;
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
      keymaps = [
        {
          key = "<leader>man";
          action = "<cmd>Telescope man_pages<CR>";
          options.desc = "Man pages";
        }
        {
          key = "<leader>ff";
          action = "<cmd>Telescope find_files<CR>";
          options.desc = "Find files";
        }
        {
          key = "<leader>fg";
          action = "<cmd>Telescope live_grep<CR>";
          options.desc = "Live grep";
        }
        {
          key = "<leader>fb";
          action = "<cmd>Telescope buffers<CR>";
          options.desc = "Find buffers";
        }
        {
          key = "<leader>fd";
          action = "<cmd>Telescope diagnostics<CR>";
          options.desc = "Diagnostics";
        }
        {
          key = "<leader>qf";
          action = "<cmd>Telescope quickfix<CR>";
          options.desc = "Quickfix";
        }
        {
          key = "<leader>git";
          action = "<cmd>LazyGit<CR>";
          options.desc = "LazyGit";
        }
        {
          key = "<leader>oil";
          action = "<cmd>Oil<CR>";
          options.desc = "Oil";
        }
      ];
    };
  };
}
