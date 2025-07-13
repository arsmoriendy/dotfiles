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

return lib
