local lib = require("lib")

-- Pull in the wezterm API
local wezterm = require("wezterm")

local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- set TERM environment variable
-- download wezterm's terminfo file from https://github.com/wez/wezterm/termwiz/data/wezterm
-- and copy to terminfo directory (usually /usr/share/terminfo/w/)
config.term = "wezterm"

config.color_scheme = "GruvboxDarkHard"

config.window_background_opacity = 0.9

config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {
  font = wezterm.font("CaskaydiaCove Nerd Font"),
  font_size = 11,
}

config.colors = {
  tab_bar = {
    background = "rgba(100% 0% 0% 50%)",
  }
}

config.font = wezterm.font("CaskaydiaCove Nerd Font Mono")
config.font_size = 11

config.window_close_confirmation = "NeverPrompt"

-- NOTE: underlines may differ from font to font
config.underline_position = "-0.1cell"
config.underline_thickness = "300%"

config.window_padding = {
  top = 0,
  left = 0,
  bottom = 0,
  right = 0,
}

-- config.enable_kitty_keyboard = true

config.adjust_window_size_when_changing_font_size = false

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.5,
}

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
