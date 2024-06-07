local function config()
  local function defaultSetupHandler(server_name)
    -- specific server configs
    local configs = {
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
            },
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
    };
    -- current config
    local srv_config = configs[server_name] or {};
    -- append default configs
    srv_config.capabilities = require("cmp_nvim_lsp").default_capabilities();   -- cmp lsp capabilities
    srv_config.on_attach = function(client, bufnr)                              -- attach nvim-navic if possible
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end
    end;
    require("lspconfig")[server_name].setup(srv_config);
  end

  -- dependency ordering matters
  require("mason").setup({
    ui = {
      border = "single",
    },
  })
  require("mason-lspconfig").setup({})
  -- automatic server config setup (:h mason-lspconfig-automatic-server-setup)
  require("mason-lspconfig").setup_handlers({
    defaultSetupHandler
  })

  require("lspconfig").dartls.setup({
    root_dir = function()
      return vim.fn.getcwd()
    end
  })
  require("lspconfig").glslls.setup({})

  -- summon ui mapping
  vim.keymap.set({ "n" }, "<Leader>m", "<Cmd>Mason<CR>")
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
