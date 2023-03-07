-- PLUGINS --
return require("packer").startup(function(use)
  -- packer.nvim
  use("wbthomason/packer.nvim")

  -- nvim-treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    opt =  false,
    run = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        auto_install = true,
        highlight = {
          enable = true
        },
        -- disable if file size > max_filesize
        disable = function(_, buf)
          local max_filesize = 1048576 -- 1 MiB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            return true
          end
        end
      })
    end
  })

  -- gruvbox.nvim
  use({
    "ellisonleao/gruvbox.nvim",
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
        overrides = {
          -- borders
          VertSplit = {bg = "None"}
        }
      })
      vim.cmd("colorscheme gruvbox")
    end
  })

  -- indent-blankline.nvim
  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("indent_blankline").setup({
        show_foldtext = false,
        show_current_context = true,
        show_current_context_start = true,
        char = "▎", -- use left aligned line
        use_treesitter = true
      })
      vim.cmd.highlight({"IndentBlanklineContextStart", "guisp=#fb4934 gui=underline"})
    end
  })

  -- lualine.nvim
  use({
    "nvim-lualine/lualine.nvim",
    config = function()
      require("lualine").setup({
        options = {
          section_separators = {left = "", right = ""},
          component_separators = {left = "╲", right = "╱"}
        },
        sections = {
          lualine_a = {
            -- vim logo
            {
              function()
                return ""
              end
            },
            -- extra symbols for submodes (eg. visual line)
            {
              function ()
                local symbol = {
                  V = "LINE", -- visual line
                  [""] = "BLOCK", -- visual block
                  s = "SELECT" -- select
                }
                -- return symbol table according to current mode or empty string if nil
                return symbol[vim.fn.mode()] or ""
              end
            },
            -- search highlight indicator
            {
              function() return vim.o.hlsearch and "" or  "" end
            }
          },
          lualine_c = {
            {
              "filename",
              newfile_status = true,
              path = 1, --relative path
              symbols = {
                modified = "●",
                readonly = "[RO]"
              }
            }
          }
        }
      })
    end,
    requires = "nvim-tree/nvim-web-devicons"
  })

  -- bufferline.nvim
  use({
    "akinsho/bufferline.nvim",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
          separator_style = "slant",
          middle_mouse_command = "bdelete! %d",
        },
        -- overrides default custom filter to none
        highlights = {
          fill = {bg = "#282828", fg = "#a89984"},
          background = {bg = "#504945", fg = "#ebdbb2"},
          tab = {bg = "#504945", fg = "#a89984"},
          close_button = {bg = "#504945", fg = "#ebdbb2"},
          separator = {bg = "#504945", fg = "#3c3836"},
          separator_visible = {bg = "#504945", fg = "#282828"},
          separator_selected = {bg = "none", fg = "#282828"},
        }
      })
    end,
    requires = "nvim-tree/nvim-web-devicons"
  })

  -- nvim-colorizer
  use({
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        user_default_options = {
          mode = "virtualtext",
          css = true
        }
      })
    end
  })

  -- ccc.nvim
  use({
    "uga-rosa/ccc.nvim",
    config = function()
      -- sets CccPick background color
      vim.cmd("highlight! link CccFloatNormal Normal")
    end
  })

  -- twilight.nvim
  use({
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
    end
  })

  -- Comment.nvim
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end
  })

  -- nvim-tree
  use({
    "nvim-tree/nvim-tree.lua",
    config = function()
      -- disable netrw (vim's built-in manager; as recomended by nvim-tree documentation)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      --
      vim.keymap.set("n", "<SPACE>", ":NvimTreeToggle<CR>", {silent = true})
      require("nvim-tree").setup()
    end,
    requires = "nvim-tree/nvim-web-devicons"
  })

  -- nvim-autopairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup()
    end
  })

  -- nvim-lspconfig (LSP configs)
  use({
    "neovim/nvim-lspconfig",
    requires = {
      -- mason.nvim (LSP auto installer)
      "williamboman/mason.nvim",
      -- mason-lspconfig.nvim (Bridges mason.nvim and nvim-lspconfig)
      "williamboman/mason-lspconfig.nvim"

    },
    config = function()
      -- dependency ordering matters
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {"lua_ls"}
      })
      -- automatic server setup (:h mason-lspconfig-automatic-server-setup)
      require("mason-lspconfig").setup_handlers({
        function (server_name) -- default handler
          require("lspconfig")[server_name].setup({})
        end
      })
      -- specific server configurations (ensure it's installed)
      require("lspconfig")["lua_ls"].setup({
        settings = {
          Lua = {
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = {'vim'},
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          }
        }
      })
    end
  })

  -- LuaSnip
  use({
    "L3MON4D3/LuaSnip",
    requires = {"rafamadriz/friendly-snippets"},
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  })

  -- nvim-cmp
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "saadparwaiz1/cmp_luasnip", -- for integration with luasnip
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer"
    },
    config = function()
      local cmp = require("cmp")
      -- cmp_next
      local cmp_next = function(fallback)
        return cmp.visible() and cmp.select_next_item() or fallback()
      end
      -- cmp_prev
      local cmp_prev = function(fallback)
        return cmp.visible() and cmp.select_prev_item() or fallback()
      end
      -- cmp_confirm
      local cmp_confirm = function(fallback)
        return cmp.visible() and cmp.confirm() or fallback()
      end
      -- cmp_scroll_docs_down
      local cmp_scroll_docs_down = function(fallback)
        return cmp.visible() and cmp.scroll_docs(1) or fallback()
      end
      -- cmp_scroll_docs_up
      local cmp_scroll_docs_up = function(fallback)
        return cmp.visible() and cmp.scroll_docs(-1) or fallback()
      end

      cmp.setup({
        mapping = {
          ["<C-n>"] = cmp.mapping({i = cmp_next}),
          ["<Down>"] = cmp.mapping({i = cmp_next}),
          ["<C-p>"] = cmp.mapping({i = cmp_prev}),
          ["<Up>"] = cmp.mapping({i = cmp_prev}),
          ["<C-down>"] = cmp.mapping({i = cmp_scroll_docs_down}),
          ["<C-up>"] = cmp.mapping({i = cmp_scroll_docs_up}),
          ["<Tab>"] = cmp.mapping({i = cmp_confirm}),
          ["<CR>"] = cmp.mapping({i = cmp_confirm}),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        sources = {
          {name = "luasnip"},
          {name = "path"},
          {name = "buffer"}
        },
        experimental = {
          ghost_text = true
        },
      })
    end
  })

  -- nvim-scrollbar
  use({
    "petertriho/nvim-scrollbar",
    requires = {
      "kevinhwang91/nvim-hlslens", -- search handler
      "lewis6991/gitsigns.nvim" -- git signs
    },
    config = function()
      require("scrollbar.handlers.search").setup({})
      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar").setup({
        handle = {
          highlight = "Visual"
        }
      })
    end
  })

  -- gitsigns.nvim
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end
  })

end)
