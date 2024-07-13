return {
  "petertriho/nvim-scrollbar",   -- scrollbar
  enabled = false,
  dependencies = {
    "kevinhwang91/nvim-hlslens", -- search handler
    "lewis6991/gitsigns.nvim"    -- git signs handler
  },
  config = function()
    require("scrollbar.handlers.search").setup({}) -- need table parameter
    require("scrollbar.handlers.gitsigns").setup()
    require("scrollbar").setup({
      hide_if_all_visible = false,
      excluded_buftypes = {
        "prompt", -- (e.g. telescope)
      },
      excluded_filetypes = {
        "alpha",
        "ccc-ui", -- colorpicker
        "DressingInput",
      },
      handle = {
        highlight = "Visual"
      }
    })
  end
}
