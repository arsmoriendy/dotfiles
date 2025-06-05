return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    oil.setup({
      keymaps = {
        ["q"] = "actions.close",
        ["<C-s>"] = false,
        ["~"] = false,
      },
    })
    vim.keymap.set("n", "-", oil.open, { desc = "Oil: Open parent directory" })
  end,
}
