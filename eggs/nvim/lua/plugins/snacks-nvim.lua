return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    input = { enabled = true, win = { border = "single" }, prompt_pos = "left" },
    indent = { enabled = true },
  },
}
