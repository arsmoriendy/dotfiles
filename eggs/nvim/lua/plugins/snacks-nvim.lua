local header = [[
    ▗▛                                            ▜▖    
   ▟▛                                              ▜▙   
  ▟▛               ▗▟█████▄▄▄▄█████▙▖               ▜▙  
 ▟█              ▗▟██████████████████▙▖              █▙ 
▐██             ▟██████████████████████▙             ██▌
 ██▙          ▗▟████████████████████████▙▖          ▟██ 
 ▐███▙▂▂   ▂▂▟████████████████████████████▙▂▂   ▂▂▟███▌ 
   ▜████████████████████████████████████████████████▛   
     ▀▀▀▀██████████████████████████████████████▀▀▀▀     
             ▀▀▀▀▀██   ▝▜██████▛▘   ██▀▀▀▀▀             
                   ▜▙    ██████    ▟▛                   
                    ▜██▆▆██████▆▆██▛                    
                     ▜████████████▛                     
                      ▜██████████▛                      
                       ▜████████▛                       
                       ██████████                       
                        ▜█▅██▅█▛                        ]]

local subheader = function()
  -- if version is under 15
  -- convert version decimal to hex for 1 digit numbers
  -- else replace with "X" as placeholder
  local function parse_hex(i)
    if i <= 15 then
      return string.upper(string.format("%x", i))
    end
    return "X"
  end

  -- neovim version
  local ver = vim.version()
  local ver_str = string.format(" v%d.%d.%d", ver.major, ver.minor, ver.patch)
  local hex_major = parse_hex(ver.major)
  local hex_minor = parse_hex(ver.minor)
  local hex_patch = parse_hex(ver.patch)

  local lazy_stats = require("lazy").stats()
  local plugins = string.format(" loaded %d/%d plugins", lazy_stats.loaded, lazy_stats.count)
  local startuptime = string.format("󰀠 %.2fms startuptime", lazy_stats.startuptime)

  local badge = {
    "+ + + + +",
    "+ N E O +",
    "+ V I M +",
    string.format("+ %s %s %s +", hex_major, hex_minor, hex_patch),
    "+ + + + +",
  }

  return table.concat({
    "NEOVIM INFORMATION        " .. badge[1],
    "------------------------- " .. badge[2],
    string.format("%-28s", ver_str) .. badge[3],
    string.format("%-28s", plugins) .. badge[4],
    string.format("%-29s", startuptime) .. badge[5],
  }, "\n")
end

local function key(desc, action)
  return { key = string.lower(string.sub(desc, 1, 1)), desc = desc, action = action }
end

-- enable dashboard only after `LazyVimStarted`
vim.api.nvim_create_autocmd("User", {
  pattern = "LazyVimStarted",
  callback = function()
    Snacks.dashboard({
      win = 1000,
      enabled = true,
      width = 35,
      preset = {
        keys = {
          key("New File", ":enew"),
          key("Plugins Profile", ":Lazy profile"),
          key("Check Plugins", ":Lazy check"),
          key("Update Plugins", ":Lazy update"),
          key("Quit", ":q"),
        },
      },
      formats = {
        key = function(item)
          return { "[" .. item.key .. "]", hl = "SnacksDashboardKey" }
        end,
      },
      sections = {
        { title = header, padding = 2 },
        { title = subheader() },
        { title = "" },
        { title = "ACTIONS" },
        { title = "-----------------------------------" },
        { section = "keys", gap = 1 },
      },
    })
  end,
})

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  config = function()
    require("snacks").setup({
      styles = {
        notification = { border = "single" },
        notification_history = { border = "single" },
        input = { border = "single" },
        zen = { width = 80 },
      },
      input = { enabled = true, prompt_pos = "title" },
      indent = { enabled = true },
      notifier = { enabled = true },
      zen = { enabled = true, toggles = { dim = false } },
    })

    vim.api.nvim_create_user_command("Notifications", Snacks.notifier.show_history, {})
    vim.api.nvim_create_user_command("ZenMode", Snacks.zen.zen, {})

    -- highlights [
    local dashboard_highlights = {
      "SnacksDashboardDir",
      "SnacksDashboardKey",
      "SnacksDashboardDesc",
      "SnacksDashboardFile",
      "SnacksDashboardIcon",
      "SnacksDashboardTitle",
      "SnacksDashboardFooter",
      "SnacksDashboardHeader",
      "SnacksDashboardNormal",
      "SnacksDashboardSpecial",
      "SnacksDashboardTerminal",
    }

    for _, dh in ipairs(dashboard_highlights) do
      vim.api.nvim_set_hl(0, dh, { link = "NonText" })
    end

    vim.api.nvim_set_hl(0, "SnacksInputBorder", { link = "FloatBorder" })
    vim.api.nvim_set_hl(0, "SnacksInputNormal", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "SnacksInputTitle", { link = "NormalFloat" })
    vim.api.nvim_set_hl(0, "SnacksNotifierHistory", { link = "NormalFloat" })
    -- ]
  end,
}
