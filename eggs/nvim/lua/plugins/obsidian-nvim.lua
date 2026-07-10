vim.cmd("cabbrev o Obsidian")

return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cmd = "Obsidian",
  ---@module 'obsidian'
  ---@type obsidian.config
  opts = {
    legacy_commands = false,
    workspaces = { { name = "main-workspace", path = "~/Documents/Sync/ObsidianVault/" } },
  },
}
