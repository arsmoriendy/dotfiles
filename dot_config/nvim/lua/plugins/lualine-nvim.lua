-- TODO: lualine_b separator color
-- TODO: tabline icon color

return {
  "nvim-lualine/lualine.nvim", -- statusline
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
    "rcarriga/nvim-notify",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local navic = require("nvim-navic")
    local notify = require("notify")
    local nwd = require("nvim-web-devicons")

    -- variables used to match active and inactive (global) [
    local sections = {
      lualine_a = {
        {
          function() return vim.fn.mode() end
        },
      },
      lualine_b = {
        -- notification indicator
        {
          function()
            local indicator = "󰂛"
            -- suppressed notifications count
            local snc = #notify.supressed_notifications

            if snc > 0 then
              indicator = indicator .. " " .. snc
            end
            return indicator
          end,
          cond = function() return notify.notification_is_supressed end,
        },
        -- snippet indicator
        {
          function() return require("luasnip").in_snippet() and "" or "" end
        },
        'branch',
        'diff',
        'diagnostics'
      },
      lualine_c = {
        {
          "filename",
          newfile_status = true,
          path = 1, --relative path
          symbols = {
            modified = "●",
            readonly = "[RO]"
          }
        }
      },
      lualine_x = { 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' }
    }

    local winbar = {
      lualine_c = {
        {
          -- NOTE: wrapper function has to be included
          function()
            local loc = navic.get_location()
            local filename = vim.fn.expand("%:t")
            local filetype_icon, filetype_icon_color = nwd.get_icon(filename)

            return string.format(
              "%%#%s#%s%%#NavicText# %s %%#NavicSeparator# %s%%#NavicText#",
              filetype_icon_color,
              filetype_icon,
              filename,
              loc
            )
          end,
          cond = navic.is_available,
        },

      },
    }
    -- ]

    require("lualine").setup({
      options = {
        section_separators = "",
        component_separators = "│",
      },
      -- statusline
      sections = sections,
      inactive_sections = sections,
      -- winbar
      winbar = winbar,
      inactive_winbar = winbar,
      -- tabline
      tabline = {
        lualine_a = {
          {
            "tabs",
            max_length = vim.o.columns,
            mode = 1,
            show_modified_status = false,
            fmt = function(name, context)
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]

              local is_modified = vim.fn.getbufvar(bufnr, "&modified")

              local filetype_icon = nwd.get_icon(name)
              local default_filetype_icon = ""

              return string.format(
                "%s %s%s",
                filetype_icon or default_filetype_icon,
                name,
                is_modified == 1 and " ●" or ""
              )
            end,
          }
        }
      },
    })
  end,
}
