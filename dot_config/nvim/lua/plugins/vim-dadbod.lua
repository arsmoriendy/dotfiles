local map = vim.keymap.set

local function split_tmp_buf()
  local buf = vim.api.nvim_create_buf(true, false)

  -- set buf options [
  local function set_opt(key, value)
    vim.api.nvim_set_option_value(key, value, { buf = buf })
  end
  local get_opt = vim.api.nvim_get_option_value

  -- sync buf's filetype with current buffer
  local ft = get_opt("filetype", { buf = vim.api.nvim_get_current_buf() })
  set_opt("filetype", ft)
  set_opt("bufhidden", "wipe")
  set_opt("buftype", "nofile")
  -- ]

  vim.cmd.sbuffer(buf)
end

local actions = {
  [1] = {
    desc = "Execute current buffer as a query",
    callback = function() vim.cmd("%DB") end,
  },
  [2] = {
    desc = "Open a temporary query buffer",
    callback = split_tmp_buf,
  },
}

local function select_actions()
  local items = vim.tbl_map(function(act) return act.desc end, actions)
  local opts = {
    prompt = "Database Actions"
  }
  local on_choice = function(_, i)
    if i ~= nil then actions[i].callback() end
  end

  vim.ui.select(items, opts, on_choice)
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Add sql/mysql keymaps",
  pattern = { "sql", "mysql" },
  callback = function(args)
    map({ "n" }, "<Leader>a", select_actions, {
      desc = "Select actions",
      buffer = args.buf
    })

    map({ "n", "i" }, "<F6>", actions[1].callback, {
      desc = actions[1].desc,
      buffer = args.buf,
    })
  end,
})

return {
  "tpope/vim-dadbod",
  cmd = "DB",
}
