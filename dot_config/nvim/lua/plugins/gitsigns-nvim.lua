return {
  "lewis6991/gitsigns.nvim",     -- git signs (next to number column) and git mappings
  config = function()
    local gitsigns = require("gitsigns")
    gitsigns.setup()
    -- mappings
    local map = vim.keymap.set
    map("n", "gn", gitsigns.next_hunk)
    map("n", "gN", gitsigns.prev_hunk)
    map("n", "gp", gitsigns.preview_hunk)
    map("n", "gd", gitsigns.diffthis)
    map("n", "gs", gitsigns.stage_hunk)
    -- stage selected
    map("x", "gs", [[<ESC>:lua require("gitsigns").stage_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>gv]])
    -- reset hunk
    map("n", "gr", gitsigns.reset_hunk)
    map("x", "gr", [[<ESC>:lua require("gitsigns").reset_hunk({vim.fn.line("'<"), vim.fn.line("'>")})<CR>gv]])
    map("n", "gR", gitsigns.reset_buffer)
  end
}
