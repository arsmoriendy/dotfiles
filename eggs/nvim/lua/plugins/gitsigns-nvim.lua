local function config()
  local gs = require("gitsigns")
  local lib = require("lib")
  local b = lib.bind
  local map = vim.keymap.set

  gs.setup({
    current_line_blame = true,
    sign_priority = 20, -- prioritize over diagnostic signs
  })

  map("n", "]g", b(gs.nav_hunk, "next"), { desc = "Go to next git hunk" })
  map("n", "[g", b(gs.nav_hunk, "prev"), { desc = "Go to previous git hunk" })
  map("n", "gpr", gs.preview_hunk, { desc = "Preview git hunk" })
  map("n", "gD", gs.diffthis, { desc = "Diffmode current file with git's staged version" })
  map("n", "gs", gs.stage_hunk, { desc = "Stage git hunk under cursor" })
  map("x", "gs", function() -- stage selected lines
    gs.stage_hunk({ vim.fn.line("'<"), vim.fn.line("'>") })
  end, { desc = "Stage selected line to git" })

  -- remove conflicting default neovim lsp keymaps that start with 'gr'
  vim.keymap.del("n", "grr")
  vim.keymap.del("n", "gri")
  vim.keymap.del({ "n", "x" }, "gra")
  vim.keymap.del("n", "grn")
  vim.keymap.del("n", "grt")

  map("n", "gr", gs.reset_hunk, { desc = "Reset git hunk under cursor" })
  map("x", "gr", function() -- reset selected lines
    gs.reset_hunk({ vim.fn.line("'<"), vim.fn.line("'>") })
  end, { desc = "Reset selected line from git" })
  map("n", "gR", gs.reset_buffer, { desc = "Reset entire buffer from git" })
  map("n", "gB", gs.blame_line, { desc = "Git blame current line" })
end

return {
  "lewis6991/gitsigns.nvim", -- git signs (next to number column) and git mappings
  event = "VeryLazy",
  config = config,
}
