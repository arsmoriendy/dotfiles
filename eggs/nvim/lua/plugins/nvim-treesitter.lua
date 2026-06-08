return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  init = function()
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        -- Enable treesitter highlighting and disable regex syntax
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
