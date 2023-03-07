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

-- toggle search highlight
vim.keymap.set({"n", "i"}, "<C-f>", function()
  vim.o.hlsearch = not(vim.o.hlsearch)
  require('lualine').refresh()
end)
-- luasnip
local luasnip = require("luasnip")
-- jump forwards in snippets if possible otherwise insert tab
vim.keymap.set("i", "<Tab>", function()
  return luasnip.jumpable() and "<Plug>luasnip-jump-next" or "<Tab>"
end, {silent = true, expr = true})
-- jump backwards in snippets
vim.keymap.set("i", "<S-Tab>", function() luasnip.jump(-1) end)

--[[ FUNCTIONS ]]
toggle_plugin_debugging = function()
  if (plugin_debbuging) then
    vim.keymap.del("n", "<F8>")
    vim.cmd("echohl DiffDelete | echo 'Debug pugins mode DISABLED!' | echohl None")
  else
    vim.keymap.set("n", "<F8>", ":luafile ~/.config/nvim/lua/plugins.lua<CR>:PackerCompile<CR>")
    vim.cmd("echohl DiffAdd | echo 'Debug pugins mode ENABLED!' | echohl None")
  end
  -- toggle plugin_debbuging variable
  plugin_debbuging = not(plugin_debbuging)
end
