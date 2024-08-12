local sprintf = string.format

---Helper for interacting with the *local lsp list file* (abbreviated as `lllf`).
---The `lllf` is usually located in `~/.local/share/nvim/local_lsp_list`.
local lllf = {
  path = vim.fs.joinpath(vim.fn.stdpath("data") --[[@as string]], "local_lsp_list")
}

-- private methods {

---Wrapper that closes and returns formatted error message
---@param file file* Lsp list file
---@return string? err
local function close(file)
  local suc, exitcode, code = file:close()
  if suc then return end
  return sprintf("Failed to close lsp list file located at %s with exitcode %s: %d",
    lllf.path, exitcode, code)
end

---Creates lsp list file and immediately closes it
---@return string? err
local function create()
  local file, err = io.open(lllf.path, "w")
  if file == nil then return err end
  return close(file)
end

---Will create lsp list file if not exist
---@param mode openmode?
---@return file*? file Lsp list file
---@return string? err
local function open(mode)
  local file, err = io.open(lllf.path, mode)
  if file == nil then
    if create() ~= nil then return nil, err end

    -- reopen file with passed in mode
    file, err = io.open(lllf.path, mode)
    if file == nil then return nil, err end
  end

  return file
end

-- private methods }

---@param name string lsp name
---@return boolean? registered
---@return integer? offset after entry
---@return string? err
function lllf.registered(name)
  local file, err = open()
  if file == nil then return nil, nil, err end

  local found = false
  for lsp in file:lines() do
    if lsp == name then
      found = true
      break
    end
  end

  local offset
  offset, err = file:seek()
  if err ~= nil then return nil, nil, err end

  err = close(file)
  if err ~= nil then return nil, nil, err end

  return found, offset
end

---@param name string lsp name
---@return string? err
function lllf.register(name)
  local registered, _, err = lllf.registered(name)
  if err ~= nil then return err end
  if registered then return sprintf("%s already registered", name) end

  local file
  file, err = open("r+")
  if file == nil then return err end

  _, err = file:seek("end")
  if err ~= nil then return err end

  _, err = file:write(name .. "\n")
  if err ~= nil then return err end

  file:flush()

  err = close(file)
  if err ~= nil then return err end
end

---@param name string lsp name
---@return string? err
function lllf.unregister(name)
  local registered, offset, err = lllf.registered(name)
  if err ~= nil then return err end
  if not registered then return sprintf("%s not registered", name) end

  local file
  file, err = open()
  if file == nil then return err end

  -- WARNING: this may break if file is super large
  local content = file:read("a")
  err = close(file)
  if err ~= nil then return err end

  local head = string.sub(content, 0, offset - (#name + 1))
  local tail = string.sub(content, offset --[[@as integer]] + 1)
  content = head .. tail

  file, err = open("w")
  if file == nil then return err end

  _, err = file:write(content)
  if err ~= nil then return err end

  file:flush()

  err = close(file)
  if err ~= nil then return err end
end

---@return string[]? servers
---@return string? err
function lllf.servers()
  local file, err = open()
  if file == nil then return nil, err end

  ---@type string[]
  local servers = {}
  for server in file:lines() do
    table.insert(servers, server)
  end

  return servers
end

return lllf
