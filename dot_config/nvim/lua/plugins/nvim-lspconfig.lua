local function config()
  local lspconfig = require("lspconfig")
  local lib = require("lib")
  local bind = lib.bind

  -- default server overrides [
  local default_lspconfig_overrides = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = function(client, bufnr) -- attach nvim-navic if possible
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end
    end
  }

  lspconfig.util.default_config = vim.tbl_extend("force",
    lspconfig.util.default_config, default_lspconfig_overrides)
  -- ]

  -- specific server overrides [
  local lua_ls_cfg = {
    settings = {
      Lua = {
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      }
    }
  }

  local emmet_ls_cfg = {
    -- add php for emmet
    filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "php" },
  }

  local intelephense_cfg = {
    telemetry = {
      enabled = false,
    },
  }

  local sqls_cfg = {
    on_attach = function(client, bufnr)
      require("sqls").on_attach(client, bufnr)
    end
  }
  -- ]

  -- dependency ordering matters
  require("mason").setup({
    ui = {
      border = "single",
    },
  })
  require("mason-lspconfig").setup({})
  -- automatic server config setup (:h mason-lspconfig-automatic-server-setup)
  require("mason-lspconfig").setup_handlers({
    function(server_name) lspconfig[server_name].setup({}) end,
    ["lua_ls"] = bind(lspconfig["lua_ls"].setup, lua_ls_cfg),
    ["emmet_ls"] = bind(lspconfig["emmet_ls"].setup, emmet_ls_cfg),
    ["intelephense"] = bind(lspconfig["intelephense"].setup, intelephense_cfg),
    ["sqls"] = bind(lspconfig["sqls"].setup, sqls_cfg),
  })

  vim.keymap.set({ "n" }, "<Leader>m", "<Cmd>Mason<CR>", { desc = "Open Mason ui" })
end

return {
  "neovim/nvim-lspconfig",               -- LSP
  dependencies = {
    "williamboman/mason.nvim",           -- mason.nvim (LSP auto installer)
    "williamboman/mason-lspconfig.nvim", -- mason-lspconfig.nvim (Bridges mason.nvim and nvim-lspconfig)
    "SmiteshP/nvim-navic",               -- winbar
    "hrsh7th/cmp-nvim-lsp",
    "nanotee/sqls.nvim",
  },
  config = config
}
