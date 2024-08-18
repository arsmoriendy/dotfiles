local function config()
  local neogit = require("neogit")
  local lib = require("lib")
  local kms = lib.kms
  local b = lib.bind

  neogit.setup({
    mappings = {
      -- disable leading <C-c> binds [
      commit_editor = {
        ["<c-c><c-c>"] = false,
        ["<c-c><c-k>"] = false,
      },
      commit_editor_I = {
        ["<c-c><c-c>"] = false,
        ["<c-c><c-k>"] = false,
      }
      -- ]
    }
  })

  vim.cmd("cabbrev G Neogit")

  kms("n", "gC", b(neogit.open, { "commit" }), "Git commit [neogit]")
  kms("n", "gp", b(neogit.open, { "pull" }), "Git pull [neogit]")
  kms("n", "gP", b(neogit.open, { "push" }), "Git push [neogit]")
end

return {
  "NeogitOrg/neogit",
  event = "VeryLazy",
  config = config,
}
