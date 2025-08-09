--- @type table<string,boolean?>
local ignored_files = {}

-- PERF: telescope file picker has the same filter
local function refresh_ignored_files()
  local proc = vim
    .system({
      "git",
      "ls-files",
      "--ignored",
      "--exclude-standard",
      -- TODO: exclude from .ignore (and possibly other files)
      -- "--exclude-from",
      -- ".ignore",
      "--others",
      "--directory",
    }, {
      text = true,
    })
    :wait()

  if proc.code ~= 0 then
    return
  end

  ignored_files = {}
  for file in proc.stdout:gmatch("[^\r\n]+") do
    ignored_files[file] = true
  end
end

refresh_ignored_files()

return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    local actions = require("oil.actions")

    -- call refresh_ignored_files on oil refresh
    local old_refresh = actions.refresh.callback
    actions.refresh.callback = function(...)
      refresh_ignored_files()
      old_refresh(...)
    end

    oil.setup({
      keymaps = {
        ["q"] = "actions.close",
        ["<C-s>"] = false,
        ["~"] = false,
      },
      float = {
        border = "single",
        max_width = 80,
      },
      view_options = {
        is_hidden_file = function(name, _)
          local m = name:match("^%.")
          if m ~= nil then
            return true
          end

          m = ignored_files[name]
          if m then
            return true
          end

          return false
        end,
      },
    })
    vim.keymap.set("n", "-", oil.open_float, { desc = "Oil: Open parent directory" })
  end,
}
