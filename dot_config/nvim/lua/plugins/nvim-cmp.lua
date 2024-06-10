local config = function()
  local cmp = require("cmp")

  local default_cfg = {
    mapping = {
      ["<C-x>"] = cmp.mapping(cmp.mapping.abort()),
      ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
      ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item()),
      ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
      ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item()),
      ["<C-down>"] = cmp.mapping(cmp.mapping.scroll_docs(1)),
      ["<C-up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1)),
      ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true })),
      ["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end
    },
    sources = {
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "path" },
      { name = "buffer" },
    },
    --[[ experimental = {
          ghost_text = true
        }, ]]
  }

  local sql_ovr = {
    sources = {
      { name = "vim-dadbod-completion" },
      { name = "buffer" },
    },
  }
  local sql_cfg = vim.tbl_deep_extend("force", default_cfg, sql_ovr)

  cmp.setup(default_cfg)
  cmp.setup.filetype("sql", sql_cfg)
  cmp.setup.filetype("mysql", sql_cfg)
end

return {
  "hrsh7th/nvim-cmp",           -- dropdown completion
  dependencies = {
    "saadparwaiz1/cmp_luasnip", -- for integration with luasnip
    "hrsh7th/cmp-nvim-lsp",     -- for integration with lsp
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
  },
  event = "VeryLazy",
  config = config,
}
