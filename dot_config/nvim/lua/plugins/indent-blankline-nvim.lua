return {
  "lukas-reineke/indent-blankline.nvim",     -- indent lines
  dependencies = "ellisonleao/gruvbox.nvim",
  main = "ibl",
  config = function()
    vim.cmd.highlight({ "IblScope", "guifg=#fb4934" })
    require("ibl").setup({
      indent = {
        char = "▏",
      },
    })
  end
}
