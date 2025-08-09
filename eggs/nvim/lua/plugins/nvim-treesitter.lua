return {
  "nvim-treesitter/nvim-treesitter", -- basic syntax logic
  config = function()
    require("nvim-treesitter.configs").setup({
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
        disable = { "dart" },
      },
      -- disable if file size > max_filesize
      disable = function(_, buf)
        local max_filesize = 1048576 -- 1 MiB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
    })
  end,
}
