local function config()
  local ufo = require("ufo")

  ufo.setup({
    provider_selector = function(bufnr, _, _)
      if #vim.lsp.get_clients({ bufnr = bufnr }) <= 0 then
        return { "lsp", "indent" }
      end

      return { "treesitter", "indent" }
    end
  })

  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
  vim.keymap.set("n", "zR", ufo.openAllFolds)
  vim.keymap.set("n", "zM", ufo.closeAllFolds)
end

return {
  "kevinhwang91/nvim-ufo", -- fold handling
  event = "VeryLazy",
  dependencies = {
    "neovim/nvim-lspconfig",
    "kevinhwang91/promise-async",
  },
  config = config
}
