local opts = {
  window = {
    width = 80,
  },
  plugins = {
    twilight = { enabled = false },
  },
}
return {
  "folke/zen-mode.nvim",
  event = "VeryLazy",
  opts = opts,
}
