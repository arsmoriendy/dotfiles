return {
  "SmiteshP/nvim-navic",     -- location in current file specifier
  config = function()
    require("nvim-navic").setup({
      separator = "  ",
      click = true,
      highlight = true,
    })
  end,
}
