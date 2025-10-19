local function config()
  local act = require("telescope.actions")
  local lib = require("lib")
  local kms = lib.kms
  local b = lib.bind

  require("telescope").setup({
    defaults = {
      borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      prompt_prefix = " ",
      mappings = {
        n = {
          ["q"] = act.close,
          ["<C-c>"] = act.close,
          ["<C-Enter>"] = act.select_tab,
          ["<C-d>"] = act.results_scrolling_down,
          ["<C-u>"] = act.results_scrolling_up,
        },
        i = {
          ["<C-c>"] = false,
          ["<C-Enter>"] = act.select_tab,
          ["<C-d>"] = act.results_scrolling_down,
          ["<C-u>"] = act.results_scrolling_up,
        },
      },
    },
    pickers = {
      man_pages = {
        sections = { "ALL" },
      },
      live_grep = {
        additional_args = {
          "--multiline", -- enables newline("\n") searching
        },
      },
    },
  })
  require("telescope").load_extension("ui-select")
  if select(1, pcall(require, "fzf_lib")) == true then
    require("telescope").load_extension("fzf")
  end
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
  -- keymaps [
  local builtin = require("telescope.builtin")
  kms("n", "<C-p>", builtin.find_files, "File picker [telescope]")
  kms("n", "<Leader>h", builtin.help_tags, "Vim help file picker [telescope]")
  kms("n", "<Leader>p", b(builtin.builtin, { include_extensions = true }), "Picker picker [telescope]")
  kms("n", "<Leader>g", builtin.git_status, "Git status file picker [telescope]")
  -- ]
end

return {
  "nvim-telescope/telescope.nvim", -- telescope
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      enabled = function() -- only enable if `make` exists
        local ok = pcall(vim.system, { "make", "--version" })
        return ok
      end,
      build = "make",
    },
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-ui-select.nvim",
  },
  config = config,
}
