-- [[ load plugins
require("plugins")
-- ]]

-- diagnostic config
vim.diagnostic.config({
  update_in_insert = true
})

-- [[ auto(load/make) views on normal buffers
local autoview_augroup = vim.api.nvim_create_augroup("autoview", {clear = true})
local normal_buftype = ""

-- mkview autocmd on window leave
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = autoview_augroup,
  callback = function ()
    if (vim.o.buftype == normal_buftype) then
      vim.cmd("mkview")
    end
  end
})

-- loadview autocmd on window enter
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = autoview_augroup,
  callback = function ()
    if (vim.o.buftype == normal_buftype) then
      vim.cmd("silent! loadview")
    end
  end
})
-- ]]

-- [[ KEYMAPS
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
-- ]]

