return {
  "petertriho/nvim-scrollbar",       -- scrollbar
  dependencies = {
    "kevinhwang91/nvim-hlslens",     -- search handler
    "lewis6991/gitsigns.nvim"        -- git signs handler
  },
  config = function()
    require("scrollbar.handlers.search").setup({})     -- need table parameter
    require("scrollbar.handlers.gitsigns").setup()
    require("scrollbar").setup({
      hide_if_all_visible = false,
      excluded_filetypes = {
        -- disable scrollbar for alpha (blank startup plugin)
        "alpha",
        "ccc-ui",
      },
      handle = {
        highlight = "Visual"
      }
    })
  end
}
