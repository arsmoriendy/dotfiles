return {
  "numToStr/Comment.nvim", -- commenting helper
  event = "VeryLazy",
  -- From neovim version 0.10.0 onwards, commenting is native.
  -- Therefore, this plugin shouldn't be needed.
  -- But for now `gcA` and `gco` maps are not natively supported.
  -- So this plugin is still used.
  -- Uncomment `cond` below to disable this plugin on neovim >= 0.10.0.
  -- cond = function()
  --   local v = vim.version()
  --   return v.major <= 0 and v.minor < 10
  -- end,
  config = function()
    require("Comment").setup()
  end
}
