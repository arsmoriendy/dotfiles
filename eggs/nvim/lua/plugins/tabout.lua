return {
  "abecodes/tabout.nvim",
  opts = {
    backwards_tabkey = "<C-q>",
    tabkey = "<C-e>",
    act_as_tab = false,
    enable_backwards = true,
  },
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}
