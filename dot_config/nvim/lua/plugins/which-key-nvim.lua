-- TODO: Passthrough <C-c> (and possibly other mappings)
-- E.g. The sequence `vg` -> wait for popup -> `<C-c>`,
--      will only close the popup,
--      but should also cancel the sequence,
--      the same way it works when not waiting for the popup.
-- TODO: Re-enable when `v%` works as intended
return {
  "folke/which-key.nvim",
  enabled = false,
  event = "VeryLazy",
  opts = {
    icons = {
      separator = "",
    },
    window = {
      border = "single",
    },
  },
}
