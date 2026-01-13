---conform.nvim is a formatter helper

local lib = require("lib")
local bind = lib.bind

local ft_by_formatters = {
  prettierd = {
    "php", -- @prettier/plugin-php
    "blade", -- @shufo/prettier-plugin-blade
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "astro",
    "css",
    "scss",
    "sass",
    "markdown",
    "json",
    "jsonc",
    "yaml",
    "graphql",
  },
  stylua = { "lua" },
  nixfmt = { "nix" },
  ruff_format = { "python" },
  nginxfmt = { "nginx" },
  shfmt = { "bash", "sh" },
  zigfmt = { "zig" },
  taplo = { "toml" },
  sqlfluff = { "sql", "mysql" },
  ["tex-fmt"] = { "tex" },
  typstyle = { "typst" },
}

local formatters_by_ft = {}
for formatter, fts in pairs(ft_by_formatters) do
  for _, ft in pairs(fts) do
    local tb = formatters_by_ft[ft]
    if tb == nil then
      formatters_by_ft[ft] = { formatter }
    else
      table.insert(formatters_by_ft[ft], formatter)
    end
  end
end

---@type boolean
vim.g.format_on_save = true

---@param global boolean
local function toggle_format_on_save(global)
  local msg = "%s format on save: %s"

  if global then
    vim.g.format_on_save = not vim.g.format_on_save

    vim.notify(msg:format("Global", vim.g.format_on_save))
  else
    local current_buf = vim.api.nvim_get_current_buf()

    if vim.b[current_buf].format_on_save == nil then
      vim.b[current_buf].format_on_save = false
    else
      vim.b[current_buf].format_on_save = not vim.b[current_buf].format_on_save
    end

    vim.notify(msg:format("Buffer", vim.b[current_buf].format_on_save))
  end
end

---@param buf number
---@return boolean should_format
local function should_format_on_save(buf)
  local buf_state = vim.b[buf].format_on_save
  if buf_state ~= nil then
    return buf_state
  end

  return vim.g.format_on_save
end

local function config()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = function(buf)
      return should_format_on_save(buf) and {} or nil
    end,
    default_format_opts = {
      lsp_format = "fallback",
    },
    formatters = {
      typstyle = {
        args = { "-l", "80", "--wrap-text" },
      },
    },
  })

  -- TODO: buffer follows global (i.e. remove buffer option) function and keymap
  lib.kms("n", "<Leader>f", conform.format, "Format file/buffer")
  lib.kms("n", "<Leader>F", bind(toggle_format_on_save, true), "Toggle formatting on save globally")
  lib.kms("n", "<Leader>Fb", bind(toggle_format_on_save), "Toggle formatting on save in current buffer")
end

return {
  "stevearc/conform.nvim",
  event = "VeryLazy",
  opts = {},
  config = config,
}
