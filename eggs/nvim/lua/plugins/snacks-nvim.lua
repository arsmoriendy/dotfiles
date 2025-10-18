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
  -- neovim version
  local nvim_version_table = vim.version()
  -- if version is under 15
  -- convert version decimal to hex for 1 digit numbers
  -- else replace with "X" as placeholder
  local parsed_major = nvim_version_table.major <= 15 and string.upper(string.format("%x ", nvim_version_table.major))
    or " X"
  local parsed_minor = nvim_version_table.minor <= 15 and string.upper(string.format("%x ", nvim_version_table.minor))
    or " X"
  local parsed_patch = nvim_version_table.patch <= 15 and string.upper(string.format("%x ", nvim_version_table.patch))
    or " X"

  local lazy_stats = require("lazy").stats()
  local plugins = lazy_stats.loaded .. "/" .. lazy_stats.count
  local startuptime = string.format("%.2f", lazy_stats.startuptime)

  return table.concat({
    "NEOVIM INFORMATION        + + + + +",
    "------------------------- + N E O +",
    string.format(
      "%-28s",
      " v" .. nvim_version_table.major .. "." .. nvim_version_table.minor .. "." .. nvim_version_table.patch
    ) .. "+ V I M +",
    string.format("%-29s", "󰒲 " .. plugins .. " plugins loaded")
      .. "+ "
      .. parsed_major
      .. parsed_minor
      .. parsed_patch
      .. "+",
    string.format("%-29s", "󰀠 " .. string.format("%.2f", startuptime) .. "ms startuptime") .. "+ + + + +",
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
      input = { enabled = true, win = { border = "single" }, prompt_pos = "title" },
      indent = { enabled = true },
    })

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
  end,
}
