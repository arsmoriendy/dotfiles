-- [[ automatically download lazy vim (package manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
else
  vim.keymap.set({"n"}, "<Leader>l", "<Cmd>Lazy<CR>")
end
vim.opt.rtp:prepend(lazypath)
-- ]]

-- [[ lazy options
local lazy_options = {
  checker = {
    -- automatically check for plugin updates
    enabled = true,
    concurrency = 1, ---@type number? set to 1 to check for updates very slowly
    notify = true, -- get a notification when new updates are found
  },
  change_detection = {
    -- automatically check for config file changes and reload the ui
    enabled = true,
    notify = true, -- get a notification when changes are found
  },
}
-- ]]

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim", -- colorscheme
    lazy = true,
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        contrast = "hard",
        transparent_mode = true,
        overrides = {
          -- borders
          VertSplit = {bg = "None"},
        }
      })
      vim.cmd([[
      colorscheme gruvbox
      highlight! link NormalFloat Pmenu
      highlight! FloatBorder guifg=#7C6F64 guibg=#504945
      highlight! link FloatTitle NormalFloat
      ]])
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter", -- basic syntax logic
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
  },

  {
    "lukas-reineke/indent-blankline.nvim", -- indent lines
    dependencies = "ellisonleao/gruvbox.nvim",
    config = function()
      require("indent_blankline").setup({
        show_foldtext = false,
        show_current_context = true,
        show_current_context_start = true,
        char = "▎", -- use left aligned line
        context_char = "▎",
        use_treesitter = true
      })
      vim.cmd.highlight({"IndentBlanklineContextStart", "gui=underline guisp=#fb4934"})
    end
  },

  {
    "nvim-lualine/lualine.nvim", -- statusline
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
            -- snippet indicator
            {
              function () return require("luasnip").in_snippet() and "" or "" end
            },
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
    dependencies = "nvim-tree/nvim-web-devicons"
  },

  {
    "akinsho/bufferline.nvim", -- tabline
    dependencies = {"nvim-tree/nvim-web-devicons", "ellisonleao/gruvbox.nvim"},
    config = function()
      require("bufferline").setup({
        options = {
          mode = "tabs",
          separator_style = "slant",
          middle_mouse_command = "bdelete! %d",
          always_show_bufferline = false,
          show_close_icon = false,
          themeable = false,
        },
        highlights = {
          fill = {bg = "#282828", fg = "#a89984"},
          background = {bg = "#504945", fg = "#ebdbb2"},
          tab = {bg = "#504945", fg = "#a89984"},
          close_button = {bg = "#504945", fg = "#ebdbb2"},
          separator = {bg = "#504945", fg = "#282828"},
          separator_selected = {bg = "none", fg = "#282828"},
          duplicate = {bg = "#504945"},
          modified = {bg = "#504945"},
        },
      })
    end,
  },

  {
    "NvChad/nvim-colorizer.lua", -- color indicator
    config = function()
      require("colorizer").setup({
        user_default_options = {
          mode = "virtualtext",
          css = true
        }
      })
    end
  },

  {
    "uga-rosa/ccc.nvim", -- color picker
    config = function()
      require("ccc").setup({
        point_char = "⠶",
        point_color = "#7C6F64",
        win_opts = {
          border = "single",
          title = "Color Picker",
        }
      })
    end
  },

  {
    "folke/twilight.nvim", -- focus on scope
    config = function()
      require("twilight").setup()
    end,
  },

  {
    "numToStr/Comment.nvim", -- commenting helper
    config = function()
      require("Comment").setup()
      local ft = require("Comment.ft")
      ft.kdl = {"// %s"}
    end
  },

  {
    "nvim-tree/nvim-tree.lua", -- file explorer
    config = function()
      vim.keymap.set("n", "<SPACE>", ":NvimTreeToggle<CR>", {silent = true})
      -- on VimEnter, if file is directory, open nvim-tree and cd into directory
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
        end
      end})
      -- highlights
      vim.cmd.highlight({"NvimTreeIndentMarker", "guifg=#504945"})
      -- setup
      require("nvim-tree").setup({
        disable_netrw = true, -- disable netrw (vim's built-in manager; as recomended by nvim-tree documentation)
        hijack_netrw = true,
        hijack_cursor = true,
        actions = {
          open_file = {
            quit_on_open = true,
          },
        },
        tab = {
          sync = {
            open = true,
            close = true,
          }
        },
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        renderer = {
          root_folder_label = false,
          indent_markers = {
            enable = true,
          }
        },
      })
    end,
    dependencies = "nvim-tree/nvim-web-devicons",
  },

  {
    "windwp/nvim-autopairs", -- auto pairing
    config = function()
      require("nvim-autopairs").setup()
    end
  },

  {
    "neovim/nvim-lspconfig", -- LSP
    dependencies = {
      "williamboman/mason.nvim", -- mason.nvim (LSP auto installer)
      "williamboman/mason-lspconfig.nvim", -- mason-lspconfig.nvim (Bridges mason.nvim and nvim-lspconfig)
      "SmiteshP/nvim-navic", -- winbar (integrate with "barbecue.nvim")
    },
    config = function()
      -- dependency ordering matters
      require("mason").setup()
      require("mason-lspconfig").setup({})
      -- automatic server config setup (:h mason-lspconfig-automatic-server-setup)
      require("mason-lspconfig").setup_handlers({
        function (server_name)
          -- specific server configs
          local configs = {
            lua_ls = {
              settings = {
                Lua = {
                  diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'},
                  },
                  workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  -- Do not send telemetry data containing a randomized but unique identifier
                  telemetry = {
                    enable = false,
                  },
                }
              }
            },
            emmet_ls = {
              -- add php for emmet
              filetypes = {"html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "php"},
            },
          };
          -- current config
          local config = configs[server_name] or {};
          -- append default configs
          config.capabilities = require("cmp_nvim_lsp").default_capabilities(); -- cmp lsp capabilities
          config.on_attach = function (client, bufnr) -- attach nvim-navic if possible
            if client.server_capabilities.documentSymbolProvider then
              require("nvim-navic").attach(client, bufnr)
            end
          end;
          require("lspconfig")[server_name].setup(config);
        end
      })

      -- summon ui mapping
      vim.keymap.set({"n"}, "<Leader>m", "<Cmd>Mason<CR>")
    end
  },

  {
    "utilyre/barbecue.nvim", -- winbar (top scope path indicator)
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
      "ellisonleao/gruvbox.nvim",
    },
    config = function ()
      require("barbecue").setup({
        show_dirname = false,
        attach_navic = false, -- prevent barbecue from automatically attaching nvim-navic
      })
    end,
  },

  {
    "L3MON4D3/LuaSnip", -- snippet engine
    dependencies = {"rafamadriz/friendly-snippets"},
    config = function()
      -- atuo load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },

  {
    "hrsh7th/nvim-cmp", -- dropdown completion
    dependencies = {
      "saadparwaiz1/cmp_luasnip", -- for integration with luasnip
      "hrsh7th/cmp-nvim-lsp", -- for integration with lsp
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer"
    },
    config = function()
      local cmp = require("cmp")
      local cmp_map_function = function(action)
        return function(fallback)
          if cmp.visible() then action() else fallback() end
        end
      end

      cmp.setup({
        mapping = {
          ["<C-n>"] = cmp.mapping({i = cmp_map_function(cmp.select_next_item)}),
          ["<Down>"] = cmp.mapping({i = cmp_map_function(cmp.select_next_item)}),
          ["<C-p>"] = cmp.mapping({i = cmp_map_function(cmp.select_prev_item)}),
          ["<Up>"] = cmp.mapping({i = cmp_map_function(cmp.select_prev_item)}),
          ["<C-down>"] = cmp.mapping({i = cmp_map_function(function() cmp.scroll_docs(1) end)}),
          ["<C-up>"] = cmp.mapping({i = cmp_map_function(function() cmp.scroll_docs(-1) end)}),
          ["<C-d>"] = cmp.mapping({i = cmp.complete}),
          ["<CR>"] = cmp.mapping({i = cmp_map_function(function() cmp.confirm({select = true}) end)}),
          ["<C-x>"] = cmp.mapping({i = cmp_map_function(cmp.abort)}),
          ["<C-c>"] = cmp.mapping({i = cmp_map_function(function() cmp.abort() vim.cmd("stopinsert") end)}),
          ["<Esc>"] = cmp.mapping({i = cmp_map_function(function() cmp.abort() vim.cmd("stopinsert") end)}),
        },
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end
        },
        sources = {
          {name = "luasnip"},
          {name = "path"},
          {name = "buffer"},
          {name = "nvim_lsp"},
        },
        experimental = {
          ghost_text = true
        },
      })
    end
  },

  {
    "petertriho/nvim-scrollbar", -- scrollbar
    dependencies = {
      "kevinhwang91/nvim-hlslens", -- search handler
      "lewis6991/gitsigns.nvim" -- git signs handler
    },
    config = function()
      require("scrollbar.handlers.search").setup({}) -- need table parameter
      require("scrollbar.handlers.gitsigns").setup()
      require("scrollbar").setup({
        hide_if_all_visible = false,
        excluded_filetypes = {
          -- disable scrollbar for alpha (blank startup plugin)
          "alpha",
          "ccc-ui",
        },
        handle = {
          highlight = "Visual"
        }
      })
    end
  },

  {
    "lewis6991/gitsigns.nvim", -- git signs (next to number column) and git mappings
    config = function()
      local gitsigns = require("gitsigns")
      gitsigns.setup()
      -- mappings
      local map = vim.keymap.set
      map("n", "gn", gitsigns.next_hunk)
      map("n", "gN", gitsigns.prev_hunk)
      map("n", "gp", gitsigns.preview_hunk)
      map("n", "gd", gitsigns.diffthis)
      map("n", "gs", gitsigns.stage_hunk)
      -- stage selected
      map("x", "gs", [[<ESC>:lua require("gitsigns").stage_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>gv]])
      -- reset hunk
      map("n", "gr", gitsigns.reset_hunk)
      map("x", "gr", [[<ESC>:lua require("gitsigns").reset_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>gv]])
      map("n", "gR", gitsigns.reset_buffer)
    end
  },

  {
    "goolord/alpha-nvim", -- startup splash screen
    config = function()
      -- highlights
      vim.cmd([[
      highlight AlphaLogo guifg=#504945
      highlight AlphaText guifg=#665C54
      highlight AlphaTextItalic guifg=#665C54 gui=italic
      highlight AlphaTextBold guifg=#665C54 gui=bold
      highlight AlphaTextBoldItalic guifg=#665C54 gui=bold,italic
      ]])

      -- header
      local header = {
        type = "text",
        val = {
          [[     ▗▛                                            ▜▖     ]],
          [[    ▟▛                                              ▜▙    ]],
          [[   ▟▛               ▗▟█████▄▄▄▄█████▙▖               ▜▙   ]],
          [[  ▟█              ▗▟██████████████████▙▖              █▙  ]],
          [[ ▐██             ▟██████████████████████▙             ██▌ ]],
          [[  ██▙          ▗▟████████████████████████▙▖          ▟██  ]],
          [[  ▐███▙▂▂   ▂▂▟████████████████████████████▙▂▂   ▂▂▟███▌  ]],
          [[    ▜████████████████████████████████████████████████▛    ]],
          [[      ▀▀▀▀██████████████████████████████████████▀▀▀▀      ]],
          [[              ▀▀▀▀▀██   ▝▜██████▛▘   ██▀▀▀▀▀              ]],
          [[                    ▜▙    ██████    ▟▛                    ]],
          [[                     ▜██▆▆██████▆▆██▛                     ]],
          [[                      ▜████████████▛                      ]],
          [[                       ▜██████████▛                       ]],
          [[                        ▜████████▛                        ]],
          [[                        ██████████                        ]],
          [[                         ▜█▅██▅█▛                         ]],
        },
        opts = {
          position = "center",
          hl = "AlphaLogo",
        },
      }
      -- subheader
      local subheader = {
        type = "text",
        val = function()
          -- neovim version
          local nvim_version_table = vim.version()
          local nvim_version =
          "v" ..
          nvim_version_table.major ..
          "." ..
          nvim_version_table.minor ..
          "." ..
          nvim_version_table.patch

          return {
            "╰ NeoVim " .. nvim_version .. " ╯",
          }
        end,
        opts = {
          position = "center",
          hl = {
            {{"AlphaText", 0, -1}, {"AlphaTextBold", 39, 45}},
          },
        },
      }
      -- button
      local button = function (val, action)
        local shortcut = string.lower(string.sub(val, 1, 1))
        local shortcut_string = "[" .. shortcut .. "]"

        return {
          type = "button",
          val = val,
          on_press = function() vim.api.nvim_input(action) end,
          opts = {
            position = "center",
            width = 35,
            hl ={{"AlphaTextBold", 0, 1}, {"AlphaTextItalic", 1, -1}},
            shortcut = shortcut_string,
            align_shortcut = "right",
            hl_shortcut = "AlphaTextBold",
            keymap = {"n", shortcut, action, {silent = true}},
          }
        }
      end
      -- button group
      local buttonGroup = {
        type = "group",
        val = {
          button("New File", ":enew <CR>"),
          button("Plugins Profile", ":Lazy profile<CR>"),
          button("Check Plugins", ":Lazy check<CR>"),
          button("Sync Plugins", ":Lazy sync<CR>"),
          button("Quit", ":q <CR>"),
        },
        opts = {
          spacing = 1,
        }
      }

      local theme = {
        layout = {
          {type = "padding", val = 10},
          header,
          {type = "padding", val = 2},
          subheader,
          {type = "padding", val = 2},
          buttonGroup,
          {type = "padding", val = 10},
        }
      }

      require("alpha").setup(theme)
    end
  },

  {
    "rcarriga/nvim-notify", -- notification
    dependencies = {
      "mrded/nvim-lsp-notify",
    },
    config = function ()
      require("notify").setup({
        background_colour = "#00000000",
        fps = 60,
      })
      require("lsp-notify").setup({
        notify = require("notify")
      })
    end,
  },

  {
    "stevearc/dressing.nvim", -- vim.ui.select vim.ui.input
    config = function ()
      require("dressing").setup({
        input = {
          -- When true, <Esc> will close the modal
          insert_only = false,

          -- These are passed to nvim_open_win
          anchor = "NW",
          border = "single",

          win_options = {
            -- Window transparency (0-100)
            winblend = 0,
          },

          -- Set to `false` to disable
          mappings = {
            n = {
              ["q"] = "Close",
            },
          },
        },
        select = {
          -- Options for built-in selector
          builtin = {
            -- These are passed to nvim_open_win
            border = "single",

            win_options = {
              -- Window transparency (0-100)
              winblend = 0,
            },

            -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- the min_ and max_ options can be a list of mixed types.
            -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
            max_height = 0.8,

            mappings = {
              ["q"] = "Close",
            },
          },
        },
      })
    end,
  },

  {
    "ellisonleao/glow.nvim", -- markdown viewer
    cmd = "Glow",
    config = function ()
      require("glow").setup({
        border = "single",
      })
      vim.keymap.set("n", "<Leader>g", "<CMD>Glow<CR>")
    end,
  }

  --[[ {
    "mhartington/formatter.nvim", -- code formatter
    dependencies = {"williamboman/mason.nvim"},
  }, ]]

},
lazy_options
)

