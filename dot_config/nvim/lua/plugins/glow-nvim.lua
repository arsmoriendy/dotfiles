return {
  "ellisonleao/glow.nvim",     -- markdown viewer
  cmd = "Glow",
  config = function()
    require("glow").setup({
      border = "single",
    })
    vim.keymap.set("n", "<Leader>g", "<CMD>Glow<CR>")
  end,
}
