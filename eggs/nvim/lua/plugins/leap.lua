vim.keymap.set({ "n", "x", "o" }, "<Tab>", "<Plug>(leap-anywhere)")
vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

local function config()
  local leap = require("leap")
  leap.opts.safe_labels = "" -- disable auto jumping on first match
  leap.opts.labels = "qwertyuiopasdfghjklzxcvbnm/.,';"
end

return {
  "ggandor/leap.nvim",
  config = config,
  event = "VeryLazy",
}
