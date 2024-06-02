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

return lib
