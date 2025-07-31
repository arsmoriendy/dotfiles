local lib = {}

---Bind arguments to a function without calling it.
---@param pfun fun(...) The function to be called
---@param ... any Arguments to be called with the pfun
---@return fun(...) newFunction A new function that calls pfun with ...
function lib.bind(pfun, ...)
  local arg = { ... }

  return function()
    ---@diagnostic disable-next-line:deprecated
    pfun(unpack(arg))
  end
end

---String reverse find character.
---@param s string String to find on
---@param c string Character to find
---@return integer index Index of last found character or 0 if not found
function lib.strrfindc(s, c)
  local i = s:len()
  while i >= 1 do
    if s:sub(i, i) == c then
      return i
    end
    i = i - 1
  end
  return 0
end

---Wrapper for vim.keymap.set with mandatory description `desc`
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string Keymap description, this will override *desc* set in *opts*
---@param opts vim.keymap.set.Opts?
function lib.kms(mode, lhs, rhs, desc, opts)
  if opts ~= nil then
    opts = vim.tbl_extend("keep", { desc = desc }, opts)
  else
    opts = { desc = desc }
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

---Buffer local wrapper for `lib.kms`
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string Keymap description, this will override *desc* set in *opts*
---@param opts vim.keymap.set.Opts?
function lib.buf_kms(mode, lhs, rhs, desc, opts)
  if opts ~= nil then
    opts = vim.tbl_extend("keep", { buffer = true }, opts)
  else
    opts = { buffer = true }
  end

  lib.kms(mode, lhs, rhs, desc, opts)
end

---Run `hook` on certain filetypes `fts`
---@param fts string[]
---@param hook function
function lib.fthook(fts, hook)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = fts,
    callback = hook,
  })
end

---Like `kms` but only applies on cerain buffers with filetype(s) `ft`
---@param fts string[]
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string Keymap description, this will override *desc* set in *opts*
---@param opts vim.keymap.set.Opts?
function lib.ftkms(fts, mode, lhs, rhs, desc, opts)
  lib.fthook(fts, function()
    lib.buf_kms(mode, lhs, rhs, desc, opts)
  end)
end

---Wrapper for notifying errors
---@param msg string
---@param title? string
---@param opts? notify.Options
function lib.error(msg, title, opts)
  opts = opts or {}
  if title ~= nil then
    opts.title = title
  end
  vim.notify(msg, vim.log.levels.ERROR, opts)
end

---Wrapper for indexing strings
---@param s string
---@param idx number
function lib.strat(s, idx)
  return s:sub(idx, idx)
end

---Use `lib.strat` instead for proper lua lsp support
getmetatable("").__index.at = lib.strat

---@param affix string
---@param use_keyword boolean? Use vim's `iskeyword` option as a delimiter
function lib.toggle_surround_at_cursor(affix, use_keyword)
  local current_buf = vim.api.nvim_get_current_buf()
  local current_win = vim.api.nvim_get_current_win()
  -- row is 1 indexed, zcol is 0 indexed
  local row, zcol = unpack(vim.api.nvim_win_get_cursor(current_win))
  local zrow, col = row - 1, zcol + 1
  local line = vim.api.nvim_get_current_line()
  local spos, epos = 1, #line -- start, end position

  ---@param c string Character
  local function is_delimiter(c)
    local match = c == affix
    if use_keyword then
      match = match or vim.fn.match(c, "\\k") == -1 -- is keyword
    else
      match = match or c:byte() <= 32 -- is whitespace
    end
    return match
  end

  local current_char = line:at(col)
  -- whitespace or eol edge case
  if current_char:byte() == nil or current_char:byte() <= 32 then
    vim.api.nvim_buf_set_text(current_buf, zrow, zcol, zrow, zcol, { affix .. affix })
    vim.api.nvim_win_set_cursor(current_win, { row, zcol + 1 })
    return
  end

  if is_delimiter(line:at(col)) then
    return
  end

  -- get epos
  for i = col, 1, -1 do
    current_char = line:at(i)

    -- check whitespace or affix
    if is_delimiter(current_char) then
      spos = i + 1
      break
    end
  end

  -- get spos
  for i = col + 1, #line do
    current_char = line:at(i)

    -- check whitespace or affix
    if is_delimiter(current_char) then
      epos = i - 1
      break
    end
  end

  local schar, echar = line:at(spos), line:at(epos)
  local zspos, zepos = spos - 1, epos - 1
  -- prefix and postfix
  local pfx_pos, pst_pos = spos - 1, epos + 1
  local pfx, pst = line:at(pfx_pos), line:at(pst_pos)
  local zpfx_pos, zpst_pos = pfx_pos - 1, pst_pos - 1

  ---@param zat integer Zero indexed at
  ---@param replacement string[]
  local function set_col(zat, replacement)
    vim.api.nvim_buf_set_text(current_buf, zrow, zat, zrow, zat + 1, replacement)
  end

  -- if surrounded by affix
  if pfx == affix and pst == affix then -- delete affix
    set_col(zpfx_pos, {})
    set_col(zpst_pos - 1, {})
  else -- add affix
    set_col(zspos, { affix .. schar })
    set_col(zepos + 1, { echar .. affix })
    vim.api.nvim_win_set_cursor(current_win, { row, zcol + 1 })
  end
end

return lib
