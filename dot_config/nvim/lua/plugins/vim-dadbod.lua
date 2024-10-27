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

local function select_url()
  local ok, dadbod_sys = pcall(require, "sysconfig.vim-dadbod-sys")

  if not ok then
    vim.notify(
      "Make sure `$HOME/.config/nvim/lua/sysconfig/vim-dadbod-sys.lua` exists and is configured properly",
      vim.log.levels.ERROR,
      { title = "Failed to load dadbod sysconfig" }
    )
    return
  end

  local urls = dadbod_sys.urls

  local items = vim.tbl_map(function(url)
    return url.name
  end, urls)
  local opts = {
    prompt = "Select Database URL",
  }
  local on_choice = function(_, i)
    if i ~= nil then
      vim.cmd("DB g:db = " .. urls[i].url)
    end
  end

  vim.ui.select(items, opts, on_choice)
end

local actions = {
  [1] = {
    desc = "Execute current buffer as a query",
    callback = function()
      vim.cmd("%DB")
    end,
  },
  [2] = {
    desc = "Open a temporary query buffer",
    callback = split_tmp_buf,
  },
  [3] = {
    desc = "Select database url",
    callback = select_url,
  },
}

local function select_actions()
  local items = vim.tbl_map(function(act)
    return act.desc
  end, actions)
  local opts = {
    prompt = "Database Actions",
  }
  local on_choice = function(_, i)
    if i ~= nil then
      actions[i].callback()
    end
  end

  vim.ui.select(items, opts, on_choice)
end

vim.api.nvim_create_autocmd("FileType", {
  desc = "Add sql/mysql keymaps",
  pattern = { "sql", "mysql" },
  callback = function(args)
    map({ "n" }, "<Leader>a", select_actions, {
      desc = "Select actions",
      buffer = args.buf,
    })

    map({ "n", "i" }, "<F6>", actions[1].callback, {
      desc = actions[1].desc,
      buffer = args.buf,
    })
  end,
})

local config = function()
  vim.cmd("cabbrev db DB")
  vim.cmd("cabbrev dbg DB g:db =")
end

return {
  "tpope/vim-dadbod",
  cmd = "DB",
  config = config,
}
