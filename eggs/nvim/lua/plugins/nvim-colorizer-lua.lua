return {
  "NvChad/nvim-colorizer.lua", -- color indicator
  event = "VeryLazy",
  config = function()
    require("colorizer").setup({
      user_default_options = {
        mode = "virtualtext",
        css = true,
      },
    })
  end,
}
