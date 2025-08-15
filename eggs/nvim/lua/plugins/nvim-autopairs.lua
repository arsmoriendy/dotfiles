return {
  "windwp/nvim-autopairs", -- auto pairing
  event = "VeryLazy",
  config = function()
    require("nvim-autopairs").setup()
  end,
}
