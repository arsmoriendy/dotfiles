local lib = {}

lib.isUnix = function()
  return package.config:sub(1, 1) == "/"
end

---Merges two or more tables. (clone of nvim's function by the same name)
--- WARNING: the first provided table's metatable will be used.
---
---@param behavior 'error'|'keep'|'force' Decides what to do if a key is found in more than one map:
---      - "error": raise an error
---      - "keep":  use value from the leftmost map
---      - "force": use value from the rightmost map
---@param ... table Two or more tables
---@return table : Merged table
lib.tbl_extend = function(behavior, ...)
  if behavior ~= "error" and behavior ~= "keep" and behavior ~= "force" then
    error('invalid "behavior": ' .. tostring(behavior))
  end

  local tbls = table.pack(...)

  if tbls.n < 2 then
    error("wrong number of arguments (given " .. tostring(1 + tbls.n) .. ", expected at least 3)")
  end

  local rtbl = tbls[1]

  for i = 2, tbls.n do
    local tbl = tbls[i]
    for key, value in pairs(tbl) do
      if rtbl[key] ~= nil then
        if behavior == "error" then
          error("key found in more than one map: " .. key)
        elseif behavior == "keep" then
          goto continue
        end
      end
      rtbl[key] = value
      ::continue::
    end
  end

  return rtbl
end

--- Extends a list-like table with the values of another list-like table.
--- (clone of nvim's function by the same name)
---
--- NOTE: This mutates dst!
---
---@generic T: table
---@param dst T List which will be modified and appended to
---@param src table List from which values will be inserted
---@param start integer? Start index on src. Defaults to 1
---@param finish integer? Final index on src. Defaults to `#src`
---@return T dst
function lib.list_extend(dst, src, start, finish)
  for i = start or 1, finish or #src do
    table.insert(dst, src[i])
  end
  return dst
end

return lib
