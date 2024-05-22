return {
  "kevinhwang91/nvim-ufo",     -- fold handling
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "kevinhwang91/promise-async",
  },
  config = function()
    vim.o.foldlevel = 99     -- Using ufo provider need a large value, feel free to decrease the value
    vim.o.foldlevelstart = 99
    -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
    vim.keymap.set("n", "zR", require("ufo").openAllFolds)
    vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
    require("ufo").setup({
      provider_selector = function(_, filetype, _)
        if (filetype == "norg") then
          return { "treesitter" }
        end
      end
    })
  end
}
