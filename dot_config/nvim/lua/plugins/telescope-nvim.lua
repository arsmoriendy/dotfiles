return {
  "nvim-telescope/telescope.nvim", -- telescope
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-tree/nvim-web-devicons",
    "rcarriga/nvim-notify",
  },
  config = function()
    local act = require("telescope.actions")
    require("telescope").setup({
      defaults = {
        borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
        prompt_prefix = " ",
        mappings = {
          n = {
            ["q"] = act.close,
            ["<C-c>"] = act.close,
            ["<C-Enter>"] = act.select_tab,
          },
          i = {
            ["<C-c>"] = false,
            ["<C-Enter>"] = act.select_tab,
          }
        },
      },
      pickers = {
        man_pages = {
          sections = { "ALL" },
        },
        live_grep = {
          additional_args = {
            "--multiline" -- enables newline("\n") searching
          }
        },
      },
    })
    require("telescope").load_extension("notify")
    require("telescope").load_extension("fzf")
    -- highlights
    vim.cmd([[
        highlight! link TelescopeNormal NormalFloat
        highlight! link TelescopeBorder FloatBorder
        highlight! link TelescopeResultsBorder TelescopeBorder
        highlight! link TelescopePreviewBorder TelescopeBorder
        highlight! link TelescopePromptBorder TelescopeBorder
        highlight! link TelescopeTitle FloatTitle
        highlight! link TelescopeResultsDiffUntracked GruvboxFg4
        highlight! link TelescopePromptCounter GruvboxFg4
        highlight! link TelescopePreviewHyphen GruvboxFg4
        ]])
    -- keymaps [[
    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<C-p>", builtin.find_files)
    vim.keymap.set("n", "<Leader>h", builtin.help_tags)
    vim.keymap.set("n", "<Leader>nh", require("telescope").extensions.notify.notify)
    vim.keymap.set("n", "<Leader>p", function() builtin.builtin({ include_extensions = true, }) end)
    -- ]]
  end,
}
