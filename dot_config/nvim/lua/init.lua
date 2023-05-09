--[[ PLUGINS (via packer) ]]
require("plugins")

--[[ COMMANDS ]]
-- diagnostic config
vim.diagnostic.config({
  update_in_insert = true
})

--[[ KEYMAPS
Consists of logical and multi-mode mappings,
singular mode and non-logical keymaps will be stored in init.vim ]]
local kms = vim.keymap.set

-- turn off search highlight until next search action (i.e. new search, next search, prev search)
kms({"n", "i", "x"}, "<C-f>", vim.cmd.nohlsearch)

-- tab navigation [[
kms({"n", "i", "x"}, "<C-Tab>", vim.cmd.tabnext)
kms({"n", "i", "x"}, "<C-S-Tab>", vim.cmd.tabprevious)
kms({"n", "i", "x"}, "<PageDown>", vim.cmd.tabnext)
kms({"n", "i", "x"}, "<PageUp>", vim.cmd.tabprevious)
-- ]]

-- navigate saves [[
kms({"n", "i", "x"}, "<C-M-u>", "<CMD>earlier 1f<CR>")
kms({"n", "i", "x"}, "<C-M-r>", "<CMD>later 1f<CR>")
-- ]]
local luasnip = require("luasnip")

-- jump forwards in snippets / tab
kms({"i", "s"}, "<Tab>", function()
  require('lualine').refresh()
  if luasnip.locally_jumpable() then
    return "<Plug>luasnip-jump-next"
  else
    return "<Tab>"
  end
end, {silent = true, expr = true})

-- jump backwards in snippets
kms({"i", "s"}, "<S-Tab>", function()
  if luasnip.jumpable() then
    luasnip.jump(-1)
  end
end)


--[[ FUNCTIONS ]]
refresh_and_compile_plugins = function()
  vim.cmd("luafile ~/.config/nvim/lua/plugins.lua")
  require("packer").compile()
end

toggle_plugin_debugging = function()
  if (plugin_debbuging) then
    vim.keymap.del("n", "<F8>")
    vim.cmd("echohl DiffDelete | echo 'Debug pugins mode DISABLED!' | echohl None")
  else
    vim.keymap.set("n", "<F8>", refresh_and_compile_plugins)
    vim.cmd("echohl DiffAdd | echo 'Debug pugins mode ENABLED!' | echohl None")

    refresh_and_compile_plugins()
  end
  -- toggle plugin_debbuging variable
  plugin_debbuging = not(plugin_debbuging)
end
