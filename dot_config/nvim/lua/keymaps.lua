-- This file consists of plugin independent maps.
-- Plugin maps are in their respective config files.

local lib = require("lib")

-- TODO: use lib.kms
local kms = vim.keymap.set
local bind = lib.bind

kms({ "n", "x" }, "gh", "0")
kms({ "n", "x" }, "gl", "$")

-- turn off search highlight until next search action (i.e. new search, next search, prev search)
kms({ "n", "i", "x" }, "<C-M-f>", vim.cmd.nohlsearch, { desc = "Temporarily disable search highlights" })

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

-- exit
kms("n", "<S-q>", "<CMD>qa!<CR>", { desc = "Exit neovim without saving" })
-- kms("n", "<C-w><C-q>", "<CMD>q!<CR>")

-- save / write file [
kms({ "n", "v", "o" }, "<C-s>", "<CMD>w<CR>", { desc = "Save file" })
-- separate insert mode mapping for going back to normal mode after saving
kms({ "i" }, "<C-s>", "<Esc><CMD>w<CR>", { desc = "Save file" })
-- ]

-- delete
kms("i", "<C-l>", "<DEL>", { desc = "Delete" })

-- yank and append line to the unnamed register (:help registers)
kms("n", "yY", '<CMD>let @" .= getline(\'.\') . "\\n"<CR>', {
  desc = "Yank and append line to the unamed register",
  silent = true,
})

-- delete and append line to the unnamed register (:help registers)
kms("n", "dD", '<CMD>let @" .= getline(\'.\') . "\\n" | d _<CR>', {
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

-- tabs [
-- NOTE: <C-6> is reserved for alternate file switching
for i = 1, 5 do
  kms({ "n", "i", "v" }, ("<C-%d>"):format(i), function()
    local tabs = vim.api.nvim_list_tabpages()
    if i > #tabs then
      return
    end
    local dest_tab = tabs[i]
    vim.api.nvim_set_current_tabpage(dest_tab)
  end, { desc = ("Go to tab %d"):format(i) })
end
-- ]

-- diagnostics [
kms("n", "<Enter>", "<CMD>lua vim.diagnostic.open_float()<CR>", { silent = true, desc = "Show diagnostic window" })
kms("n", "<Tab>", "<CMD>lua vim.diagnostic.goto_next()<CR>", { silent = true, desc = "Go to next diagnostic" })
kms("n", "<S-Tab>", "<CMD>lua vim.diagnostic.goto_prev()<CR>", { silent = true, desc = "Go to previous diagnostic" })
-- ]

-- stop snippet
kms("i", "<C-x>", bind(require("vim.snippet").stop), { desc = "Stop snippet" })

-- lsp rename
kms("n", "<Leader>r", "<CMD>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })

-- lsp hover
kms("n", "<Leader>k", "<CMD>lua vim.lsp.buf.hover()<CR>", { desc = "Simulate hover symbol" })

-- lsp go to definition
kms("n", "<Leader>d", "<CMD>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })

-- lsp action
kms("n", "<Leader>a", "<CMD>lua vim.lsp.buf.code_action()<CR>", { desc = "Select lsp actions" })

-- lsp toggle inlay hints
kms("n", "<Leader>k", function()
  local buf = vim.api.nvim_get_current_buf()
  local buf_clients = vim.lsp.get_clients({ bufnr = buf })

  local inlay_capable = false
  for _, client in pairs(buf_clients) do
    if client.server_capabilities.inlayHintProvider then
      inlay_capable = true
    end
  end

  if not inlay_capable then
    vim.notify("No LSPs in current buffer supports inlay hints", vim.log.levels.ERROR)
    return
  end

  local inlay_is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
  vim.lsp.inlay_hint.enable(not inlay_is_enabled, { bufnr = buf })
end, { desc = "Toggle lsp inlay hints in buffer" })

kms("n", "==", "<CMD>mkview<CR>gg=G<CMD>loadview<CR>", { desc = "Reindent all lines" })

kms("n", "<Leader>l", "<CMD>Lazy<CR>", { desc = "Open lazy.nvim UI" })

-- quick fix [
kms("n", "cn", "<CMD>cnext<CR>", { desc = "Go to next entry on quickfix list" })
kms("n", "cp", "<CMD>cNext<CR>", { desc = "Go to previous entry on quickfix list" })
kms("n", "cN", "<CMD>cNext<CR>", { desc = "Go to previous entry on quickfix list" })
-- ]

-- file specific keymaps [
-- typst
lib.fthook({ "typst" }, function()
  -- bold/italicize keymaps
  -- NOTE: Originally, <C-i> was considered for italicization in insert mode. However, <C-i> is equivalent to <Tab> within terminals.
  lib.buf_kms(
    { "n", "i" },
    "<Leader>i",
    bind(lib.toggle_surround_at_cursor, "_", true),
    "Toggle word italication [typst]"
  )
  lib.buf_kms({ "n", "i" }, "<Leader>I", bind(lib.toggle_surround_at_cursor, "_"), "Toggle WORD italication [typst]")
  lib.buf_kms({ "n", "i" }, "<Leader>b", bind(lib.toggle_surround_at_cursor, "*", true), "Toggle word bold [typst]")
  lib.buf_kms({ "n", "i" }, "<Leader>B", bind(lib.toggle_surround_at_cursor, "*"), "Toggle WORD bold [typst]")
end)
-- ]
