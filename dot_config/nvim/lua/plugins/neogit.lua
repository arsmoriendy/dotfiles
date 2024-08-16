local function config()
  local neogit = require("neogit")
  local lib = require("lib")
  local kms = lib.kms
  local b = lib.bind

  neogit.setup({
    mappings = {
      commit_editor = {
        ["<C-c><C-c>"] = false,
        ["<Enter><Enter>"] = "Submit",
      }
    }
  })

  vim.cmd("cabbrev G Neogit")

  kms("n", "gC", b(neogit.open, { "commit" }), "Git commit")
end

return {
  "NeogitOrg/neogit",
  event = "VeryLazy",
  config = config,
}
