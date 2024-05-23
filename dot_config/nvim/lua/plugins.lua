-- automatically download lazy vim (package manager) [
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
else
  vim.keymap.set({ "n" }, "<Leader>l", "<Cmd>Lazy<CR>")
end
vim.opt.rtp:prepend(lazypath)
-- ]

-- lazy options [
local lazy_options = {
}
-- ]

local lazy_plugins = {
  {
    require("plugins.gruvbox-nvim"),
    require("plugins.nvim-treesitter"),
    require("plugins.indent-blankline-nvim"),
    require("plugins.nvim-navic"),
    require("plugins.lualine-nvim"),
    require("plugins.nvim-colorizer-lua"),
    require("plugins.ccc-nvim"),
    require("plugins.twilight-nvim"),
    require("plugins.Comment-nvim"),
    require("plugins.nvim-autopairs"),
    require("plugins.nvim-lspconfig"),
    require("plugins.LuaSnip"),
    require("plugins.nvim-cmp"),
    require("plugins.nvim-scrollbar"),
    require("plugins.gitsigns-nvim"),
    require("plugins.alpha-nvim"),
    require("plugins.nvim-notify"),
    require("plugins.dressing-nvim"),
    require("plugins.glow-nvim"),
    require("plugins.nvim-ufo"),
    require("plugins.telescope-nvim"),
    require("plugins.telescope-fzf-native-nvim"),
    require("plugins.todo-comments-nvim"),
    require("plugins.oil-nvim"),
  }
}

require("lazy").setup(
  lazy_plugins,
  lazy_options
)
