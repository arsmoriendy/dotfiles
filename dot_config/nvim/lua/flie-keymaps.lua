local cau = vim.api.nvim_create_autocmd
local lib = require("lib")
local kms = lib.kms

--- ConTeXt main file name
---@type string
local ctx_main_file
---Returns wether a ConTeXt file is a main file (i.e. not an environment, component, etc).
---Does not check for file extension.
---@param ctx_fn string A ConTeXt filename (not path)
---@return boolean
local function is_ctx_main(ctx_fn)
  -- TODO: check after "_"
  local splitidx = lib.strrfindc(ctx_fn, '_')
  if splitidx == 0 then
    return true
  end
  return false
end
cau("FileType", {
  desc = "Enable ConTeXt keymaps",
  pattern = "context",
  callback = function()
    vim.notify("Using ConTeXt keymaps")

    local buf = vim.api.nvim_get_current_buf()
    local bufname = vim.api.nvim_buf_get_name(buf)
    local buf_fn = bufname:sub(lib.strrfindc(bufname, '/') + 1)

    if is_ctx_main(buf_fn) then
      ctx_main_file = bufname
    end

    local compile = function()
      if ctx_main_file == nil then
        vim.notify("Unknown ConTeXt main file", vim.log.levels.ERROR)
        return
      end
      vim.cmd(string.format("!context '%s'", ctx_main_file))
    end

    kms("n", "<F5>", function()
      vim.cmd("write")
      compile()
    end, "Save and Compile ConTeXt file")
  end
})
