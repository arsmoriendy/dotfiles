local lib = require("lib")

-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {
  -- set TERM environment variable
  -- download wezterm's terminfo file from https://github.com/wez/wezterm/termwiz/data/wezterm
  -- and copy to terminfo directory (usually /usr/share/terminfo/w/)
  term = "wezterm",
  color_scheme = "GruvboxDarkHard",
  window_background_opacity = 0.9,
  -- config.hide_tab_bar_if_only_one_tab = true
  window_frame = {
    font = wezterm.font("CaskaydiaCove Nerd Font"),
    font_size = 11,
  },
  colors = {
    tab_bar = {
      background = "rgba(100% 0% 0% 50%)",
    }
  },
  font = wezterm.font("CaskaydiaCove Nerd Font Mono"),
  font_size = 11,
  window_close_confirmation = "NeverPrompt",
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
}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
    config = lib.tbl_extend('error', wezterm.config_builder(), config)
end

local keymaps = require("keymaps")
config = lib.tbl_extend("force", config, keymaps)


if (lib.isUnix()) then
  -- [[ unix only config
  config.window_decorations = "None"
  -- ]]
else
  -- [[ windows only config
  -- use git's included bash.exe as a default shell
  config.default_prog = { "C:\\Program Files\\Git\\bin\\bash.exe" }
  -- ]]
end

-- and finally, return the configuration to wezterm
return config
