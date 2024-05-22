return {
  "folke/twilight.nvim",     -- focus on scope
  cmd = "Twilight",
  config = function()
    require("twilight").setup()
  end,
}
