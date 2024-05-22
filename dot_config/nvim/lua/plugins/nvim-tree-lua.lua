return {
  "nvim-tree/nvim-tree.lua",     -- file explorer
  config = function()
    vim.keymap.set("n", "<SPACE>", ":NvimTreeToggle<CR>", { silent = true })
    -- on VimEnter, if file is directory, open nvim-tree and cd into directory
    vim.api.nvim_create_autocmd({ "VimEnter" }, {
      callback = function(data)
        if vim.fn.isdirectory(data.file) == 1 then
          vim.cmd.cd(data.file)
          require("nvim-tree.api").tree.open()
        end
      end
    })
    -- highlights
    vim.cmd.highlight({ "NvimTreeIndentMarker", "guifg=#504945" })
    -- setup
    require("nvim-tree").setup({
      disable_netrw = true,     -- disable netrw (vim's built-in manager; as recomended by nvim-tree documentation)
      hijack_netrw = true,
      hijack_cursor = true,
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
      tab = {
        sync = {
          open = true,
          close = true,
        }
      },
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      renderer = {
        root_folder_label = false,
        indent_markers = {
          enable = true,
        }
      },
    })
  end,
  dependencies = "nvim-tree/nvim-web-devicons",
}
