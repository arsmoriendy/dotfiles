return {
  "numToStr/Comment.nvim",     -- commenting helper
  config = function()
    require("Comment").setup()
    local ft = require("Comment.ft")
    ft.kdl = { "// %s" }
  end
}
