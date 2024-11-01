---conform.nvim is a formatter helper

local lib = require("lib")

local formatters_by_ft = {
  javascript = { "prettierd" },
  javascriptreact = { "prettierd" },
  typescript = { "prettierd" },
  typescriptreact = { "prettierd" },
  astro = { "prettierd" },
  css = { "prettierd" },
  scss = { "prettierd" },
  sass = { "prettierd" },
  markdown = { "prettierd" },
  json = { "prettierd" },
  yaml = { "prettierd" },
  graphql = { "prettierd" },
  lua = { "stylua" },
}

-- global format on save {
---@type boolean
vim.g.format_on_save = true

---@return boolean
local function getg()
  return vim.g.format_on_save
end
---
---@param state boolean
local function setg(state)
  vim.g.format_on_save = state
end

local function toggle_g_format_on_save_wrapper()
  -- toggle global format on save
  setg(not getg())

  local msg = string.format("%s formatting on save globally", getg() and "Enabled" or "Disabled")
  vim.notify(msg)
end
-- }

-- buffer format on save {
---@return boolean|nil
local function gets(bufn)
  return vim.b[bufn].format_on_save
end

---@param bufn number
---@param state boolean
local function sets(bufn, state)
  vim.b[bufn].format_on_save = state
end

local function toggle_current_b_format_on_save()
  local current_bufn = vim.api.nvim_get_current_buf()

  -- init or toggle
  if gets(current_bufn) == nil then
    sets(current_bufn, false)
  else
    sets(
      current_bufn,
      ---@diagnostic disable-next-line:param-type-mismatch
      not gets(current_bufn)
    )
  end

  local msg = string.format("%s formatting on save in current file", gets(current_bufn) and "Enabled" or "Disabled")
  vim.notify(msg)
end

---@return conform.FormatOpts|nil
local function format_on_save(bufn)
  local b = gets(bufn)
  if b ~= nil then
    return b and {} or nil
  end

  return getg() and {} or nil
end
-- }

local function config()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = format_on_save,
    default_format_opts = {
      lsp_format = "fallback",
    },
  })

  lib.kms("n", "<Leader>i", conform.format, "Format file/buffer")
  lib.kms("n", "<Leader>I", toggle_g_format_on_save_wrapper, "Toggle formatting on save globally")
  lib.kms("n", "<Leader>Ib", toggle_current_b_format_on_save, "Toggle formatting on save in current file")
end

return {
  "stevearc/conform.nvim",
  opts = {},
  config = config,
}
