return {
  "ellisonleao/gruvbox.nvim", -- colorscheme
  lazy = true,
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      contrast = "hard",
      transparent_mode = true,
      overrides = {
        -- borders
        VertSplit = { bg = "None" },

        -- float [
        NormalFloat = { bg = "#3C3836", fg = "#EBDBB2", },
        FloatTitle = { bg = "#3C3836", fg = "#EBDBB2", },
        FloatBorder = { bg = "#3C3836", fg = "#7C6F64", },
        -- ]

        -- winbar [
        WinBar = { bg = "None", fg = "#a89984", },
        NavicText = { fg = "#a89984", },
        NavicSeparator = { fg = "#7C6F64", },
        -- ]
      }
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
