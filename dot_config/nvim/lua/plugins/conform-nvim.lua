local lib = require("lib")

local formatters_by_ft = {
  javascript = { "prettierd" },
  javascriptreact = { "prettierd" },
  typescript = { "prettierd" },
  typescriptreact = { "prettierd" },
  css = { "prettierd" },
  scss = { "prettierd" },
  sass = { "prettierd" },
  markdown = { "prettierd" },
  json = { "prettierd" },
  yaml = { "prettierd" },
  graphql = { "prettierd" },
  lua = { "stylua" },
}

local format_on_save = true
local toggle_format_on_save = function()
  format_on_save = not format_on_save
  vim.notify("Format on save: " .. tostring(format_on_save))
end

local function config()
  local conform = require("conform")

  conform.setup({
    formatters_by_ft = formatters_by_ft,
    format_on_save = function()
      return format_on_save and {} or nil
    end,
    default_format_opts = {
      lsp_format = "fallback",
    },
  })

  lib.kms("n", "<Leader>i", conform.format, "Format file/buffer")
  lib.kms("n", "<Leader>I", toggle_format_on_save, "Toggle format on save")
end

return {
  "stevearc/conform.nvim",
  opts = {},
  config = config,
}
