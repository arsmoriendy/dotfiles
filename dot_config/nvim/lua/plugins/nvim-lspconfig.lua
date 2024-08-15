local function config()
  local lspconfig = require("lspconfig")
  local mason = require("mason")
  local mason_lspconfig = require("mason-lspconfig")

  local lllf = require("lib.lllf")
  local lib = require("lib")

  -- default server overrides [
  local default_lspconfig_overrides = {
    -- This function is called by the "VeryLazy" event, therefore autostarting may not work
    autostart = false,
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

  -- TODO: dynamic config https://www.reddit.com/r/neovim/comments/19dodgd/how_can_i_dynamicly_change_lsp_configuration/

  -- specific server overrides
  local lspconfig_overrides = {
    -- This lua_ls configuration mainly adheres to neovim's lua runtime
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
          runtime = {
            version = "Lua 5.1", -- Adhere to neovim's lua runtime version 5.1
            path = { "?.lua", "?/init.lua", "/lua/?.lua", "/lua/?/init.lua", },
            pathStrict = true,
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
  local function mason_lspcfg_default_handler(server_name)
    -- TODO: lift this into a function
    lspconfig[server_name].setup(lspconfig_overrides[server_name] or {})
  end

  -- dependency ordering matters
  mason.setup({
    ui = {
      border = "single",
    },
  })
  mason_lspconfig.setup({
    -- automatic server config setup (:h mason-lspconfig-automatic-server-setup)
    handlers = { mason_lspcfg_default_handler }
  })

  vim.keymap.set({ "n" }, "<Leader>m", "<Cmd>Mason<CR>", { desc = "Open Mason ui" })

  local all_lsps = mason_lspconfig.get_available_servers()

  local local_lsps, err = lllf.servers()
  if local_lsps == nil and err ~= nil then
    lib.error(err, "Failed getting local lsp list")
    return
  end
  for _, local_lsp in pairs(local_lsps --[[@as string[] ]]) do
    lspconfig[local_lsp].setup(lspconfig_overrides[local_lsp] or {})
  end

  local function reg_local_lsp()
    local mason_installed_lsps = mason_lspconfig.get_installed_servers()
    local items = vim.tbl_filter(function(lsp)
      return not vim.list_contains(mason_installed_lsps, lsp)
    end, all_lsps)

    vim.ui.select(items, { prompt = "Register local lsp" }, function(name)
      if name == nil then return end

      err = lllf.register(name)
      if err ~= nil then
        lib.error(err, "Failed writting to local lsp list file, aborting.")
        return
      end

      lspconfig[name].setup(lspconfig_overrides[name] or {})
    end)
  end

  local function unreg_local_lsp()
    local_lsps, err = lllf.servers()
    if local_lsps == nil and err ~= nil then
      lib.error(err)
      return
    end

    local on_select = function(name)
      if name == nil then return end
      err = lllf.unregister(name)
      if err ~= nil then lib.error(err) end
    end
    vim.ui.select(local_lsps --[[@as string[] ]], { prompt = "Unregister local lsp" }, on_select)
  end

  lib.kms("n", "<Leader>nr", reg_local_lsp, "Register local lsp")
  lib.kms("n", "<Leader>nu", unreg_local_lsp, "Unregister local lsp")

  -- Manually start lsps, because by default autostart is false
  vim.cmd("LspStart")
end

return {
  "neovim/nvim-lspconfig",               -- LSP
  dependencies = {
    "williamboman/mason.nvim",           -- mason.nvim (LSP auto installer)
    "williamboman/mason-lspconfig.nvim", -- mason-lspconfig.nvim (Bridges mason.nvim and nvim-lspconfig)
    "SmiteshP/nvim-navic",               -- winbar
    "hrsh7th/cmp-nvim-lsp",
  },
  -- Neovim's runtimepath is needed by lua_ls to properly lookup modules, therefore, this
  -- ensures neovim's runtimepath is initialized completely before calling the config function.
  event = "VeryLazy",
  config = config
}
