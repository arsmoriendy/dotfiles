return {
  "hrsh7th/nvim-cmp",               -- dropdown completion
  dependencies = {
    "saadparwaiz1/cmp_luasnip",     -- for integration with luasnip
    "hrsh7th/cmp-nvim-lsp",         -- for integration with lsp
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer"
  },
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      mapping = {
        ["<C-x>"] = cmp.mapping(cmp.mapping.abort()),
        ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item()),
        ["<Down>"] = cmp.mapping(cmp.mapping.select_next_item()),
        ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item()),
        ["<Up>"] = cmp.mapping(cmp.mapping.select_prev_item()),
        ["<C-down>"] = cmp.mapping(cmp.mapping.scroll_docs(1)),
        ["<C-up>"] = cmp.mapping(cmp.mapping.scroll_docs(-1)),
        ["<CR>"] = cmp.mapping(cmp.mapping.confirm({ select = true })),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete({
          config = {
            sources = {
              { name = "nvim_lsp" }
            }
          }
        })),
      },
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end
      },
      sources = {
        { name = "luasnip" },
        { name = "path" },
        { name = "buffer" },
        { name = "nvim_lsp" },
      },
      --[[ experimental = {
          ghost_text = true
        }, ]]
    })
  end
}
