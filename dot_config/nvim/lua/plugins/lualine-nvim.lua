-- TODO: lualine_b separator color
-- TODO: default tabline filetype icon light color (nvim-web-devicons)
-- TODO: derive statusline filetype icon from filetype and not file extension

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
    local nwd_light = require("nvim-web-devicons.icons-light").icons_by_file_extension

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
            -- HACK: Set to really big number because highlight escape
            -- characters adds to the overall length of each tab.
            -- TODO: Fix horizontal scroll when tabline overflows.
            -- [
            tab_max_length = 999,
            max_length = 999,
            -- ]
            mode = 1,
            show_modified_status = false,
            fmt = function(name, context)
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]

              local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
              local ext = nwd.get_icon_name_by_filetype(ft)
              local icon_tbl = nwd_light[ext] or nwd.get_default_icon()

              local tab_icon_hi = "lualine_tab" .. context.tabnr .. "_icon"

              local is_curr = vim.api.nvim_get_current_tabpage() == context.tabnr
              local bg_hi = is_curr and "lualine_a_tabs_active" or "lualine_a_tabs_inactive"

              local bg_c = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(bg_hi)), "bg#")

              local icon = string.format(
                "%%#%s#%s%%#%s#",
                tab_icon_hi,
                icon_tbl.icon,
                bg_hi
              )

              local is_modified = vim.fn.getbufvar(bufnr, "&modified")

              vim.cmd.highlight({
                tab_icon_hi,
                "guifg=" .. icon_tbl.color,
                "guibg=" .. bg_c
              })

              return string.format(
                "%s %s%s",
                icon,
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
