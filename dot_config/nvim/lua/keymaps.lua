-- This file consists of plugin independent maps.
-- Plugin maps are in their respective config files.

local kms = vim.keymap.set

-- turn off search highlight until next search action (i.e. new search, next search, prev search)
kms({ "n", "i", "x" }, "<C-f>", vim.cmd.nohlsearch, { desc = "Temporarily disable search highlights" })

-- tab navigation [
kms({ "n", "i", "x" }, "<C-Tab>", vim.cmd.tabnext, { desc = "Go to next tab" })
kms({ "n", "i", "x" }, "<C-S-Tab>", vim.cmd.tabprevious, { desc = "Go to previous tab" })
kms({ "n", "i", "x" }, "<PageDown>", vim.cmd.tabnext, { desc = "Go to next tab" })
kms({ "n", "i", "x" }, "<PageUp>", vim.cmd.tabprevious, { desc = "Go to previous tab" })
-- ]

-- window resize [
kms("n", "<C-w>h", "<CMD>vertical resize -5<CR>", { desc = "Reduce window size vertically" })
kms("n", "<C-w>j", "<CMD>resize +5<CR>", { desc = "Add window size horizontally" })
kms("n", "<C-w>k", "<CMD>resize -5<CR>", { desc = "Reduce window size horizontally" })
kms("n", "<C-w>l", "<CMD>vertical resize +5<CR>", { desc = "Add window size vertically" })
-- ]

-- navigate saves [
kms({ "n", "i", "x" }, "<C-M-u>", "<CMD>earlier 1f<CR>", { desc = "Undo to last save" })
kms({ "n", "i", "x" }, "<C-M-r>", "<CMD>later 1f<CR>", { desc = "Redo to next save" })
-- ]

kms({ "n" }, "<Leader>f", "za", { desc = "Toggle fold" })

-- exit
kms("n", "<S-q>", "<CMD>qa!<CR>", { desc = "Exit neovim without saving" })
-- kms("n", "<C-w><C-q>", "<CMD>q!<CR>")

-- save / write file [
kms({ "n", "v", "o" }, "<C-s>", "<CMD>w<CR>", { desc = "Save file" })
-- separate insert mode mapping for going back to normal mode after saving
kms({ "i" }, "<Esc><C-s>", "<CMD>w<CR>", { desc = "Save file" })
-- ]

-- delete
kms("i", "<C-l>", "<DEL>", { desc = "Delete" })

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
kms("n", "<C-h>", "<C-w>h", { remap = false, desc = "Go to left window" })
kms("n", "<C-j>", "<C-w>j", { remap = false, desc = "Go to down window" })
kms("n", "<C-k>", "<C-w>k", { remap = false, desc = "Go to up window" })
kms("n", "<C-l>", "<C-w>l", { remap = false, desc = "Go to right window" })
-- ]
-- close window
kms({ "n", "v", "o" }, "<C-q>", "<C-w>q", { desc = "Close window" })
-- ]

-- diagnostics [
kms("n", "<Enter>", "<CMD>lua vim.diagnostic.open_float()<CR>", { silent = true, desc = "Show diagnostic window" })
kms("n", "<Tab>", "<CMD>lua vim.diagnostic.goto_next()<CR>", { silent = true, desc = "Go to next diagnostic" })
kms("n", "<S-Tab>", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { silent = true, desc = "Go to previous diagnostic" })
-- ]

-- lsp rename
kms("n", "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })

-- lsp format
kms("n", "<Leader>i", "<CMD>lua vim.lsp.buf.format()<CR>", { desc = "Reformat buffer" })

-- lsp hover
kms("n", "<Leader>k", "<CMD>lua vim.lsp.buf.hover()<CR>", { desc = "Simulate hover symbol" })

-- lsp go to definition
kms("n", "<Leader>d", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" });

-- lsp action
kms("n", "<Leader>a", "<CMD>lua vim.lsp.buf.code_action()<CR>", { desc = "Select lsp actions" });

kms("n", "==", "<CMD>mkview<CR>gg=G<CMD>loadview<CR>", { desc = "Reindent all lines" })

kms("n", "<Leader>l", "<CMD>Lazy<CR>", { desc = "Open lazy.nvim UI" })

-- quick fix [
kms("n", "cn", "<CMD>cnext<CR>", { desc = "Go to next entry on quickfix list" })
kms("n", "cp", "<CMD>cNext<CR>", { desc = "Go to previous entry on quickfix list" })
kms("n", "cN", "<CMD>cNext<CR>", { desc = "Go to previous entry on quickfix list" })
-- ]
