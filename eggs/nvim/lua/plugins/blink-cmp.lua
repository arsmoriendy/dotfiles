vim.cmd([[
highlight link BlinkCmpSignatureHelpBorder FloatBorder
highlight link BlinkCmpDocBorder FloatBorder
highlight link BlinkCmpDocSeparator FloatBorder
]])

return {
  "saghen/blink.cmp",
  event = "VeryLazy",
  -- provides snippets for the snippet source
  dependencies = { "rafamadriz/friendly-snippets" },

  -- use a release tag to download pre-built binaries
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    completion = { menu = { border = "none" } },
  },
}
