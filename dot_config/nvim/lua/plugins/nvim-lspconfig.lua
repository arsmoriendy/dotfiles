local function config()
  local lspconfig = require("lspconfig")
  local lib = require("lib")
  local bind = lib.bind

  -- default server overrides [
  local default_lspconfig_overrides = {
    capabilities = vim.tbl_deep_extend("force",
      require("cmp_nvim_lsp").default_capabilities(),
      {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          }
        }
      }),
    on_attach = function(client, bufnr)
      -- attach nvim-navic if possible
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end
    end
  }

  lspconfig.util.default_config = vim.tbl_extend("force",
    lspconfig.util.default_config, default_lspconfig_overrides)
  -- ]

  -- specific server overrides
  local lspconfig_overrides = {
    lua_ls = {
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
          }
        }
      }
    },
    emmet_ls = {
      -- add php for emmet
      filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "eruby", "php" },
    },
    intelephense = {
      telemetry = {
        enabled = false,
      },
    },
    tsserver = {
      init_options = {
        preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
    gopls = {
      settings = {
        gopls = {
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          }
        }
      }
    },
  }

  -- dependency ordering matters
  require("mason").setup({
    ui = {
      border = "single",
    },
  })
  require("mason-lspconfig").setup({})
  -- automatic server config setup (:h mason-lspconfig-automatic-server-setup)
  require("mason-lspconfig").setup_handlers({
    function(server_name) lspconfig[server_name].setup(lspconfig_overrides[server_name] or {}) end,
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
  },
  config = config
}
