local keymaps = {}

local wezterm = require('wezterm')
local act = wezterm.action

-- tmux style prefix key
local prefix_key = "a"

keymaps.key_tables = {
  resize_pane = {
    {
      key = "h",
      action = act.AdjustPaneSize({ "Left", 5 }),
    },
    {
      key = "j",
      action = act.AdjustPaneSize({ "Down", 5 }),
    },
    {
      key = "k",
      action = act.AdjustPaneSize({ "Up", 5 }),
    },
    {
      key = "l",
      action = act.AdjustPaneSize({ "Right", 5 }),
    },
    {
      key = "q",
      action = "PopKeyTable",
    },
  },
  search_mode = {
    { key = "c",         mods = "CTRL", action = act.CopyMode 'Close' },
    { key = 'Escape',    mods = 'NONE', action = act.CopyMode 'Close' },
    { key = 'Enter',     mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'n',         mods = 'CTRL', action = act.CopyMode 'NextMatch' },
    { key = 'p',         mods = 'CTRL', action = act.CopyMode 'PriorMatch' },
    { key = 'r',         mods = 'CTRL', action = act.CopyMode 'CycleMatchType' },
    { key = 'u',         mods = 'CTRL', action = act.CopyMode 'ClearPattern' },
    { key = 'PageUp',    mods = 'NONE', action = act.CopyMode 'PriorMatchPage' },
    { key = 'PageDown',  mods = 'NONE', action = act.CopyMode 'NextMatchPage' },
    { key = 'UpArrow',   mods = 'NONE', action = act.CopyMode 'PriorMatch' },
    { key = 'DownArrow', mods = 'NONE', action = act.CopyMode 'NextMatch' },
  },
  prefix = {
    { -- exit prefix mode
      key = prefix_key,
      mods = "CTRL",
      action = act.PopKeyTable
    },
    {
      key = "z",
      action = act.TogglePaneZoomState
    },
    {
      key = "[",
      action = act.ActivateCopyMode,
    },
    {
      key = "/",
      action = act.Search({ CaseInSensitiveString = "" }),
    },
  },
}

keymaps.keys = {
  {
    key = "l",
    mods = "ALT|SHIFT",
    action = act.SplitHorizontal,
  },
  {
    key = "j",
    mods = "ALT|SHIFT",
    action = act.SplitVertical,
  },
  {
    key = "q",
    mods = "ALT",
    action = act.CloseCurrentPane({ confirm = false }),
  },
  {
    key = "q",
    mods = "ALT|CTRL",
    action = act.CloseCurrentTab({ confirm = false }),
  },
  {
    key = "l",
    mods = "ALT",
    action = act.ActivatePaneDirection("Right"),
  },
  {
    key = "j",
    mods = "ALT",
    action = act.ActivatePaneDirection("Down"),
  },
  {
    key = "h",
    mods = "ALT",
    action = act.ActivatePaneDirection("Left"),
  },
  {
    key = "k",
    mods = "ALT",
    action = act.ActivatePaneDirection("Up"),
  },
  {
    key = "x",
    mods = "ALT",
    action = act.ActivateCopyMode,
  },
  {
    key = "r",
    mods = "ALT",
    action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false, }),
  },
  {
    key = "c",
    mods = "ALT",
    action = act.CharSelect,
  },
  {
    key = "Enter",
    mods = "ALT",
    action = act.SpawnTab("CurrentPaneDomain"),
  },
  { -- activate prefix keytable
    key = prefix_key,
    mods = "CTRL",
    action = act.ActivateKeyTable({ name = "prefix" })
  },
}

-- ALT + n to activate nth tab
for n = 1, 9 do
  table.insert(keymaps.keys, {
    key = tostring(n),
    mods = 'ALT',
    action = act.ActivateTab(n - 1),
  })
end

return keymaps
