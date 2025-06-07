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
      float = {
        border = "single",
        max_width = 80,
      },
    })
    vim.keymap.set("n", "-", oil.open_float, { desc = "Oil: Open parent directory" })
  end,
}
