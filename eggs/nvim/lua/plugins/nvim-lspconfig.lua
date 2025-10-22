local function config()
  local lspconfig = require("lspconfig")

  local lllf = require("lib.lllf")
  local lib = require("lib")
  local config_path = vim.uv.fs_realpath(vim.fn.stdpath("config"))

  -- extend default lspconfig
  lspconfig.util.default_config = vim.tbl_deep_extend("force", lspconfig.util.default_config, {
    capabilities = {
      workspace = {
        executeCommand = {
          dynamicRegistration = true,
        },
      },
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    },
    on_attach = function(client, bufnr)
      -- attach nvim-navic if possible
      if client.server_capabilities.documentSymbolProvider then
        require("nvim-navic").attach(client, bufnr)
      end
    end,
  })

  -- TODO: dynamic config https://www.reddit.com/r/neovim/comments/19dodgd/how_can_i_dynamicly_change_lsp_configuration/
  -- maybe pair that with lspconfig `on_new_config` key

  -- specific server overrides
  local lspconfig_overrides = {
    -- This lua_ls configuration mainly adheres to neovim's lua runtime
    lua_ls = {
      on_init = function(client)
        local current_path = client.workspace_folders[1].name
        if current_path == config_path then
          client.config.settings.Lua.workspace = {
            library = vim.api.nvim_list_runtime_paths(),
          }
        end
      end,
      settings = {
        Lua = {
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    },

    emmet_language_server = {
      filetypes = {
        "html",
        "typescriptreact",
        "javascriptreact",
        "css",
        "sass",
        "scss",
        "less",
        "eruby",
        "php",
      },
    },
    intelephense = {
      telemetry = {
        enabled = false,
      },
    },
    ts_ls = {
      init_options = {
        preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          importModuleSpecifierPreference = "non-relative",
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
          },
        },
      },
    },
    texlab = {
      settings = {
        texlab = {
          build = {
            executable = "tectonic",
            args = {
              "-X",
              "build",
            },
          },
        },
      },
    },
  }

  local function setup_lsp(name)
    vim.lsp.config(name, vim.tbl_deep_extend("force", lspconfig.util.default_config, lspconfig_overrides[name] or {}))
    -- disable lsp on diff mode
    if vim.wo[vim.api.nvim_get_current_win()].diff then
      return
    end
    vim.lsp.enable(name)
  end

  local local_lsps, err = lllf.servers()
  if local_lsps == nil and err ~= nil then
    lib.error(err, "Failed getting local lsp list")
    return
  end
  for _, local_lsp in
    pairs(local_lsps --[[@as string[] ]])
  do
    setup_lsp(local_lsp)
  end

  local function reg_local_lsp()
    local lsp_registry_path = vim.fs.joinpath(config_path, "lsp-registry.json")
    local lsp_registry_file = io.open(lsp_registry_path)
    if lsp_registry_file == nil then
      vim.notify("Mason registry file not found", "error")
      return
    end
    local lsp_registry = vim.json.decode(lsp_registry_file:read("*a"))

    vim.ui.select(lsp_registry, {
      prompt = "Register local lsp:",
      format_item = function(p)
        local name = p.name
        local github_stars = p.github_stars ~= vim.NIL and "" .. vim.inspect(p.github_stars) or ""
        local languages = vim.inspect(p.languages)
        return string.format("%s: %s %s", name, languages, github_stars)
      end,
    }, function(p, _)
      if p == nil then
        return
      end

      local lsp_name = p.neovim.lspconfig

      err = lllf.register(lsp_name)
      if err ~= nil then
        lib.error(err, "Failed writting to local lsp list file, aborting.")
        return
      end

      setup_lsp(lsp_name)
    end)
  end

  local function unreg_local_lsp()
    local_lsps, err = lllf.servers()
    if local_lsps == nil and err ~= nil then
      lib.error(err)
      return
    end

    local on_select = function(name)
      if name == nil then
        return
      end
      err = lllf.unregister(name)
      if err ~= nil then
        lib.error(err)
      end
    end
    vim.ui.select(local_lsps --[[@as string[] ]], { prompt = "Unregister local lsp" }, on_select)
  end

  lib.kms("n", "<Leader>mr", reg_local_lsp, "Register local lsp")
  lib.kms("n", "<Leader>mu", unreg_local_lsp, "Unregister local lsp")
end

return {
  "neovim/nvim-lspconfig", -- LSP
  dependencies = {
    "SmiteshP/nvim-navic", -- winbar
  },
  -- Neovim's runtimepath is needed by lua_ls to properly lookup modules, therefore, this
  -- ensures neovim's runtimepath is initialized completely before calling the config function.
  event = "VeryLazy",
  config = config,
}
