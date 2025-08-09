return {
  "uga-rosa/ccc.nvim", -- color picker
  cmd = "Ccc",
  config = function()
    require("ccc").setup({
      point_char = "⠶",
      point_color = "#7C6F64",
      win_opts = {
        border = "single",
        title = "Color Picker",
      },
    })
  end,
}
