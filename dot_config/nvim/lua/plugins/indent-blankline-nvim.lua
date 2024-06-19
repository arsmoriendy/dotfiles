return {
  "lukas-reineke/indent-blankline.nvim", -- indent lines
  dependencies = "ellisonleao/gruvbox.nvim",
  main = "ibl",
  config = function()
    local char = "▏"
    vim.cmd.highlight({ "IblScope", "guifg=#fb4934" })
    require("ibl").setup({
      indent = {
        char = char,
      },
    })
    vim.opt.listchars:append(string.format("tab:%s ", char))
  end
}
