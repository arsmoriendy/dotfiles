local keymaps = {}

local wezterm = require('wezterm')
local act = wezterm.action

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
  }
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
    action = act.InputSelector({
      title = "Quit",
      choices = {
        { label = "Close pane", },
        { label = "Close tab", },
      },
      action = wezterm.action_callback(function(_, pane, _, label)
        if label == "Close pane" then
          pane:move_to_new_tab()
          act.CloseCurrentPane({ confirm = false })
        end
      end),
    }),
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
