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
          always_show_bufferline = false,
        },
        highlights = {
          fill = {bg = "#282828", fg = "#a89984"},
          background = {bg = "#504945", fg = "#ebdbb2"},
          tab = {bg = "#504945", fg = "#a89984"},
          close_button = {bg = "#504945", fg = "#ebdbb2"},
          separator = {bg = "#504945", fg = "#3c3836"},
          separator_visible = {bg = "#504945", fg = "#282828"},
          separator_selected = {bg = "none", fg = "#282828"},
        },
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
    end,
  })

  -- twilight.nvim
  use({
    "folke/twilight.nvim",
    config = function()
      require("twilight").setup()
    end,
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
      vim.keymap.set("n", "<SPACE>", ":NvimTreeToggle<CR>", {silent = true})
      -- on VimEnter, if file is directory, open nvim-tree and cd into directory
      vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
        end
      end})
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
        view = {
          hide_root_folder = true,
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
          indent_markers = {
            enable = true,
          }
        },
      })
    end,
    requires = "nvim-tree/nvim-web-devicons",
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
      "williamboman/mason.nvim", -- mason.nvim (LSP auto installer)
      "williamboman/mason-lspconfig.nvim", -- mason-lspconfig.nvim (Bridges mason.nvim and nvim-lspconfig)
      "SmiteshP/nvim-navic", -- winbar (integrate with "barbecue.nvim")
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
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            on_attach = function (client, bufnr)
              if client.server_capabilities.documentSymbolProvider then
                require("nvim-navic").attach(client, bufnr)
              end
            end,
          })
        end
      })
      -- specific server configurations (ensure it's installed)
      local lspconfig = require("lspconfig")
      -- lua_ls
      lspconfig["lua_ls"].setup({
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
      -- atuo load snippets from friendly-snippets
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  })

  -- nvim-cmp
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "saadparwaiz1/cmp_luasnip", -- for integration with luasnip
      "hrsh7th/cmp-nvim-lsp", -- for integration with lsp
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer"
    },
    config = function()
      local cmp = require("cmp")
      -- function biolerplate -> function(fallback)
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
            ["<PageDown>"] = cmp.mapping({i = cmp_map_function(function() cmp.scroll_docs(1) end)}),
            ["<C-up>"] = cmp.mapping({i = cmp_map_function(function() cmp.scroll_docs(-1) end)}),
            ["<PageUp>"] = cmp.mapping({i = cmp_map_function(function() cmp.scroll_docs(-1) end)}),
            ["<Right>"] = cmp.mapping({i = cmp_map_function(function() cmp.confirm({select = true}) end)}),
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
    })

    -- barbecue.nvim (winbar)
    use({
      "utilyre/barbecue.nvim",
      requires = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },
      after = "gruvbox.nvim",
      config = function ()
        require("barbecue").setup({
          attach_navic = false,
          show_dirname = false,
        })
      end,
    })

    -- nvim-scrollbar
    use({
      "petertriho/nvim-scrollbar",
      requires = {
        "kevinhwang91/nvim-hlslens", -- search handler
        "lewis6991/gitsigns.nvim" -- git signs handler
      },
      config = function()
        require("scrollbar.handlers.search").setup({}) -- need table argument
        require("scrollbar.handlers.gitsigns").setup()
        require("scrollbar").setup({
          excluded_filetypes = {
            -- disable scrollbar for alpha (blank startup plugin)
            "alpha",
          },
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
        local gitsigns = require("gitsigns")
        gitsigns.setup()
        -- mappings
        local map = vim.keymap.set
        map("n", "gn", gitsigns.next_hunk)
        map("n", "gN", gitsigns.prev_hunk)
        map("n", "gp", gitsigns.preview_hunk)
        map("n", "gd", gitsigns.diffthis)
      end
    })

    -- aplha-nvim (startup/dashboard plugin)
    use({
      "goolord/alpha-nvim",
      config = function()
        -- highlights
        vim.cmd([[
        highlight AlphaLogo guifg=#504945
        highlight AlphaText guifg=#665C54
        highlight AlphaTextBold guifg=#665C54 gui=bold
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
              "╰─────────[ NeoVim " .. nvim_version .. " ]─────────╯",
            }
          end,
          opts = {
            position = "center",
            hl = {
              {{"AlphaText", 1, -1}, {"AlphaTextBold", 39, 45}},
            },
          },
        }
        -- button
        local button = function (icon, val, action, shortcut)
          return {
            type = "button",
            val = icon .. " " .. val,
            on_press = function() vim.api.nvim_input(action) end,
            opts = {
              position = "center",
              width = 35,
              cursor = 4,
              hl = {{"AlphaTextBold", 0, 3}, {"AlphaText", 4, -1}},
              shortcut = "[" .. shortcut .. "]",
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
            button("", "New File", ":enew <CR>", "i"),
            button("", "Plugin Status", ":PackerStatus <CR>", "s"),
            button("", "Compile Plugins", ":PackerCompile <CR>", "c"),
            button("", "Update Plugins", ":PackerSync <CR>", "u"),
            button("", "Quit", ":q <CR>", "q"),
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
    })
  end)

