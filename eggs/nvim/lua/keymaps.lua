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

-- navigate saves [
kms({ "n", "i", "x" }, "<C-M-u>", "<CMD>earlier 1f<CR>", { desc = "Undo to last save" })
kms({ "n", "i", "x" }, "<C-M-r>", "<CMD>later 1f<CR>", { desc = "Redo to next save" })
-- ]

-- quit
local function quit()
  -- get modified files
  local modified_files = {}
  local bufs = vim.api.nvim_list_bufs()
  for _, b in ipairs(bufs) do
    local is_modified = vim.api.nvim_get_option_value("modified", { buf = b })
    if is_modified then
      local name = vim.api.nvim_buf_get_name(b)
      table.insert(modified_files, name)
    end
  end

  if #modified_files < 1 then
    return vim.cmd("qa!")
  end

  lib.float_prompt({
    title = "Quit?",
    messages = { "The following files are modified:", "", unpack(modified_files) },
    actions = {
      { name = "[D]iscard All", shortcut = "d", callback = ":qa!<CR>" },
      { name = "[C]ancel", shortcut = "c", callback = "<C-w>q" },
    },
  })
end
kms("n", "<Leader><Leader>", quit, { desc = "Quit neovim" })

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
