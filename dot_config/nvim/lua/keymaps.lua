-- This file consists of plugin independent maps.
-- Plugin maps are in their respective config files.

local kms = vim.keymap.set

-- turn off search highlight until next search action (i.e. new search, next search, prev search)
kms({ "n", "i", "x" }, "<C-f>", vim.cmd.nohlsearch)

-- tab navigation [
kms({ "n", "i", "x" }, "<C-Tab>", vim.cmd.tabnext)
kms({ "n", "i", "x" }, "<C-S-Tab>", vim.cmd.tabprevious)
kms({ "n", "i", "x" }, "<PageDown>", vim.cmd.tabnext)
kms({ "n", "i", "x" }, "<PageUp>", vim.cmd.tabprevious)
-- ]

-- window resize [
kms("n", "<C-w>h", "<CMD>vertical resize -5<CR>")
kms("n", "<C-w>j", "<CMD>resize +5<CR>")
kms("n", "<C-w>k", "<CMD>resize -5<CR>")
kms("n", "<C-w>l", "<CMD>vertical resize +5<CR>")
-- ]

-- navigate saves [
kms({ "n", "i", "x" }, "<C-M-u>", "<CMD>earlier 1f<CR>")
kms({ "n", "i", "x" }, "<C-M-r>", "<CMD>later 1f<CR>")
-- ]

kms({ "n" }, "<Leader>f", "za") -- toggle fold

-- reload config
-- TODO: account for windows init.lua path
kms("n", "<F5>", "<CMD>source ~/.config/nvim/init.lua<CR>")

-- exit
kms("n", "<S-q>", "<CMD>qa!<CR>")
-- kms("n", "<C-w><C-q>", "<CMD>q!<CR>")

-- save / write file [
kms({ "n", "v", "o" }, "<C-s>", "<CMD>w<CR>")
-- separate insert mode mapping for going back to normal mode after saving
kms({ "i" }, "<C-s>", "<ESC><CMD>w<CR>")
-- ]

-- delete
kms("i", "<C-l>", "<DEL>")

-- yank and append line to the unnamed register (:help registers)
kms("n", "yY", "<CMD>let @\" .= getline('.') . \"\\n\"<CR>", {
  desc = "Yank and append line to the unamed register",
  silent = true,
})

-- delete and append line to the unnamed register (:help registers)
kms("n", "dD", "<CMD>let @\" .= getline('.') . \"\\n\" | d _<CR>", {
  desc = "Delete and append line to the unamed register",
  silent = true,
})

-- windows [
-- navigate windows [
kms("n", "<C-h>", "<C-w>h", { remap = false })
kms("n", "<C-j>", "<C-w>j", { remap = false })
kms("n", "<C-k>", "<C-w>k", { remap = false })
kms("n", "<C-l>", "<C-w>l", { remap = false })
-- ]
-- close window
kms({ "n", "v", "o" }, "<C-q>", "<C-w>q")
-- ]

-- diagnostics [
kms("n", "<Enter>", "<CMD>lua vim.diagnostic.open_float()<CR>", { silent = true })
kms("n", "<Tab>", "<CMD>lua vim.diagnostic.goto_next()<CR>", { silent = true })
kms("n", "<S-Tab>", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { silent = true })
-- ]

-- lsp rename
kms("n", "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>")

-- lsp format
kms("n", "<Leader>i", "<CMD>lua vim.lsp.buf.format()<CR>")

-- lsp hover
kms("n", "<Leader>k", "<CMD>lua vim.lsp.buf.hover()<CR>")

-- lsp go to definition
kms("n", "<Leader>d", "<CMD>lua vim.lsp.buf.definition()<CR>");

-- lsp action
kms("n", "<Leader>a", "<CMD>lua vim.lsp.buf.code_action()<CR>");

kms("n", "==", "<CMD>mkview<CR>gg=G<CMD>loadview<CR>", { desc = "Reindent all lines" })

kms("n", "<Leader>l", "<CMD>Lazy<CR>", { desc = "Open lazy.nvim UI" })
