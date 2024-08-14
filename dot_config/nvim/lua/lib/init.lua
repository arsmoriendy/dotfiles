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

---Wrapper for vim.keymap.set
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string Keymap description, this will override *desc* set in *opts*
---@param opts table?
function lib.kms(mode, lhs, rhs, desc, opts)
  if opts ~= nil then
    opts = vim.tbl_extend("keep", { desc = desc }, opts)
  else
    opts = { desc = desc }
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

---Wrapper for notifying errors
---@param msg string
---@param title? string
---@param opts? notify.Options
function lib.error(msg, title, opts)
  opts = opts or {}
  if title ~= nil then opts.title = title end
  vim.notify(msg, vim.log.levels.ERROR, opts)
end

return lib
