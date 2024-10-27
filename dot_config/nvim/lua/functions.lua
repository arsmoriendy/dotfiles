-- TODO: refactor to table

-- NOTE: Use `:lua =<table>` instead
-- table to string
--
-- https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
-- @param o table to be stringified
function dump(o)
  if type(o) == "table" then
    local s = "{ \n"
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. dump(v) .. ",\n"
    end
    return s .. "} "
  else
    return "'" .. tostring(o) .. "'"
  end
end
