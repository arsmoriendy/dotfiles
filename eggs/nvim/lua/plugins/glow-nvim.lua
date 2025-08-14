return {
  "ellisonleao/glow.nvim", -- markdown viewer
  ft = "markdown",
  config = function()
    require("glow").setup({
      border = vim.o.winborder,
    })
    vim.keymap.set("n", "<Leader>g", "<CMD>Glow<CR>")
  end,
}
