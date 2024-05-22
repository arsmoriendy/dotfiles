return {
  "lukas-reineke/indent-blankline.nvim",     -- indent lines
  dependencies = "ellisonleao/gruvbox.nvim",
  main = "ibl",
  config = function()
    vim.cmd.highlight({ "IblScope", "guifg=#fb4934" })
    require("ibl").setup({
      scope = {
        highlight = {
          "IblScope"
        }
      },
      exclude = {
        filetypes = {
          -- defaults
          'lspinfo',
          "packer",
          "checkhealth",
          "help",
          "man",
          "gitcommit",
          "TelescopePrompt",
          "TelescopeResults",
          "''",
          -- custom
          "norg",
        }
      },
      indent = {
        tab_char = "▎"
      },
    })
  end
}
