return {
  "stevearc/dressing.nvim", -- vim.ui.select vim.ui.input
  event = "VeryLazy",
  config = function()
    require("dressing").setup({
      input = {
        win_options = {
          -- Window transparency (0-100)
          winblend = 0,
        },

        -- Set to `false` to disable
        mappings = {
          n = {
            ["q"] = "Close",
            ["<C-c>"] = "Close",
          },
          i = {
            ["<C-c>"] = false,
          },
        },

        override = function(conf)
          conf.border = vim.o.winborder
          return conf
        end,
      },
      select = {
        -- Options for built-in selector
        builtin = {
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

          override = function(conf)
            conf.border = vim.o.winborder
            return conf
          end,
        },
      },
    })
  end,
}
