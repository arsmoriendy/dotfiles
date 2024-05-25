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
opt.wrap = false
opt.autoread = true
opt.softtabstop = 2
opt.shiftwidth = 2
opt.updatetime = 100
opt.listchars:append("trail:•")
opt.rtp:prepend(lazypath)
-- ]

-- VARIABLES [
-- vanilla vim variables
vim.g.mapleader = "\\"
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
  update_in_insert = true
})

-- recognize "*.swayconfig" files as swayconfig files
vim.filetype.add({
  extension = {
    swayconfig = "swayconfig"
  }
})
-- ]

-- AUTO GROUP/CMDS [

-- auto(load/make) views on normal buffer types [
local autoview_augroup = vim.api.nvim_create_augroup("autoview", { clear = true })

-- mkview autocmd on window leave
vim.api.nvim_create_autocmd("BufWinLeave", {
  group = autoview_augroup,
  callback = function()
    if (vim.o.buftype == "" and vim.fn.bufname() ~= "") then
      vim.cmd("mkview")
    end
  end
})

-- loadview autocmd on window enter
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = autoview_augroup,
  callback = function()
    if (vim.o.buftype == "" and vim.fn.bufname() ~= "") then
      vim.cmd("silent! loadview")
    end
  end
})
-- ]

-- ]

-- load config from different files [
require("functions")
require("keymaps")
require("lazy").setup(
  "plugins", -- import plugins (:h lazy.nvim-lazy.nvim-structuring-your-plugins)
  {
    change_detection = {
      notify = false,
    },
  }
)
-- ]
