return {
  "L3MON4D3/LuaSnip", -- snippet engine
  event = "VeryLazy",
  dependencies = { "rafamadriz/friendly-snippets" },
  config = function()
    -- atuo load snippets from friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()
    local luasnip = require("luasnip")
    -- jump forwards in snippets / tab
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      require("lualine").refresh({ place = { "statusline" } })
      if luasnip.locally_jumpable() then
        return "<Plug>luasnip-jump-next"
      else
        return "<Tab>"
      end
    end, { silent = true, expr = true })
    -- jump backwards in snippets
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      if luasnip.jumpable() then
        luasnip.jump(-1)
      end
    end)
  end
}
