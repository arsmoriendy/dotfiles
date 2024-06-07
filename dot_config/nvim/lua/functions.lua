-- TODO: refactor to table
--
-- NOTE: Use `:lua =<table>` instead
-- table to string
--
-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- @param o table to be stringified
function dump(o)
  if type(o) == 'table' then
    local s = '{ \n'
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ',\n'
    end
    return s .. '} '
  else
    return "'" .. tostring(o) .. "'"
  end
end

--- WARNING: experimental
function open_temp_sql_win()
  local buf = vim.api.nvim_create_buf(true, false)

  -- sync buf's filetype with current buffer
  local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_get_current_buf() })
  vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })

  vim.api.nvim_set_option_value("buftype", "", { buf = buf })

  -- TODO: lookup other ways to do this
  -- TODO: cleanup on window close
  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local width_ratio = 0.7
  local height_ratio = 0.1
  local window_w = screen_w * width_ratio
  local window_h = screen_h * height_ratio
  local window_w_int = math.floor(window_w)
  local window_h_int = math.floor(window_h)
  local center_x = (screen_w - window_w) / 2
  local center_y = ((vim.opt.lines:get() - window_h) / 2)
      - vim.opt.cmdheight:get()

  -- open buf in a floating window
  local title = "Temporary SQL Buffer"
  vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    col = center_x,
    row = center_y,
    width = window_w_int,
    height = window_h_int,
    border = "single",
    title = title,
    title_pos = "center",
    zindex = 1,
  })
end
