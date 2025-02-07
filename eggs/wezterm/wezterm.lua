local lib = require("lib")

-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {
  automatically_reload_config = false,
  -- set TERM environment variable
  -- download wezterm's terminfo file from https://github.com/wez/wezterm/termwiz/data/wezterm
  -- and copy to terminfo directory (usually /usr/share/terminfo/w/)
  term = "wezterm",
  color_scheme = "GruvboxDarkHard",
  window_frame = {
    font = wezterm.font("CaskaydiaCove Nerd Font"),
  },
  window_background_opacity = 0.9,
  show_new_tab_button_in_tab_bar = false,
  show_tab_index_in_tab_bar = false,
  use_fancy_tab_bar = false,
  colors = {
    tab_bar = {
      background = "#0c0d0e",
      active_tab = {
        bg_color = "#181a1b",
        fg_color = "#FBF1C7",
      },
      inactive_tab = {
        bg_color = "#0c0d0e",
        fg_color = "#665C54",
      },
    },
  },
  font = wezterm.font("CaskaydiaCove Nerd Font Mono"),
  set_environment_variables = {
    TERM_NF_ENABLED = "true", -- specify nerd font support
  },
  font_size = 11,
  window_close_confirmation = "NeverPrompt",
  front_end = "WebGpu",

  -- NOTE: underlines may differ from font to font
  underline_position = "-0.1cell",
  underline_thickness = "300%",

  window_padding = {
    top = 0,
    left = 0,
    bottom = 0,
    right = 0,
  },
  -- config.enable_kitty_keyboard = true
  adjust_window_size_when_changing_font_size = false,
  inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.5,
  },
  -- {% if SYSTEM.platform == "Windows" %}
  --<yolk> default_prog = { "nu" },
  -- {% end %}
}

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
local function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
  local prefix = "[" .. tab.tab_index + 1 .. "] "
  local title = tab_title(tab)
  local padding = " "

  title = title:sub(1, max_width - #padding - #prefix) .. padding

  return {
    { Foreground = { Color = "#FABD2F" } },
    { Text = prefix },
    "ResetAttributes",
    { Text = title },
  }
end)

wezterm.on("update-status", function(window, _)
  local name = window:active_key_table()
  if name then
    name = "TABLE: " .. name
  end
  window:set_right_status(name or "")
end)

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = lib.tbl_extend("error", wezterm.config_builder(), config)
end

local keymaps = require("keymaps")
config = lib.tbl_extend("force", config, keymaps)

-- and finally, return the configuration to wezterm
return config
