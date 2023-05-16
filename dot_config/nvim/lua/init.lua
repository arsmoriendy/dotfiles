--[[ PLUGINS ]]
require("plugins")

--[[ COMMANDS ]]
-- diagnostic config
vim.diagnostic.config({
  update_in_insert = true
})

--[[ KEYMAPS ]]
-- Consists of mappings that are not dependent on plugins
-- plugin dependent maps are stored in plugins.lua
local kms = vim.keymap.set

-- turn off search highlight until next search action (i.e. new search, next search, prev search)
kms({"n", "i", "x"}, "<C-f>", vim.cmd.nohlsearch)

-- tab navigation [[
kms({"n", "i", "x"}, "<C-Tab>", vim.cmd.tabnext)
kms({"n", "i", "x"}, "<C-S-Tab>", vim.cmd.tabprevious)
kms({"n", "i", "x"}, "<PageDown>", vim.cmd.tabnext)
kms({"n", "i", "x"}, "<PageUp>", vim.cmd.tabprevious)
-- ]]

-- window resize [[
kms("n", "<C-w>h", "<CMD>vertical resize -5<CR>")
kms("n", "<C-w>j", "<CMD>resize +5<CR>")
kms("n", "<C-w>k", "<CMD>resize -5<CR>")
kms("n", "<C-w>l", "<CMD>vertical resize +5<CR>")
-- ]]

-- navigate saves [[
kms({"n", "i", "x"}, "<C-M-u>", "<CMD>earlier 1f<CR>")
kms({"n", "i", "x"}, "<C-M-r>", "<CMD>later 1f<CR>")
-- ]]

-- folds [[
kms({"n"}, "<Leader>f", "za") -- toggle fold
-- ]]

