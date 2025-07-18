local lib = require("lib")
local fthook = lib.fthook

-- download and install lazy.nvim package manager, if not already installed [
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
-- ]

-- OPTIONS [
-- vanilla vim options (set only)
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.showmode = false
opt.termguicolors = true
opt.expandtab = true
opt.list = true
opt.cursorline = true
opt.ignorecase = true
opt.smartcase = true
opt.autoread = true
opt.softtabstop = 2
opt.shiftwidth = 2
opt.updatetime = 100
opt.listchars:append("trail:•")
opt.rtp:prepend(lazypath)
opt.breakindent = true
opt.scrolloff = 3
opt.spelllang = "en,id"
-- ]

-- VARIABLES [
-- disable <C-C> maps on sql files
vim.g.omni_sql_no_default_maps = 1
-- ]

-- COMMANDS [
-- vanilla vim ex-commands

-- command abbreviations [
vim.cmd.cabbrev("th tab help")
-- ]

-- ]

-- LUA APIS [
vim.diagnostic.config({
  update_in_insert = true,
})

-- recognize "*.swayconfig" files as swayconfig files
vim.filetype.add({
  extension = {
    swayconfig = "swayconfig",
    zathurarc = "zathurarc",
    context = "context",
  },
})
-- ]

-- AUTO GROUP/CMDS [

-- auto(load/make) views on normal buffer types [
local autoview_augroup = vim.api.nvim_create_augroup("autoview", { clear = true })

-- mkview autocmd on window leave
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = autoview_augroup,
  callback = function()
    if vim.o.buftype == "" and vim.fn.bufname() ~= "" then
      vim.cmd("mkview")
    end
  end,
})

-- loadview autocmd on window enter
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = autoview_augroup,
  callback = function()
    if vim.o.buftype == "" and vim.fn.bufname() ~= "" then
      vim.cmd("silent! loadview")
    end
  end,
})
-- ]

fthook({ "go" }, function()
  vim.opt_local.expandtab = false
  vim.opt_local.shiftwidth = 0
end)

fthook({ "python" }, function()
  vim.opt_local.shiftwidth = 0
end)

-- ]

vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- load config from different files [
require("keymaps")
require("file-keymaps")
require("lazy").setup(
  "plugins", -- import plugins (:h lazy.nvim-lazy.nvim-structuring-your-plugins)
  {
    ui = {
      border = "single",
      title = " Plugins ",
    },
    change_detection = {
      notify = false,
    },
  }
)
-- ]
