return {
  "nvim-lualine/lualine.nvim",     -- statusline
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("lualine").setup({
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "╲", right = "╱" },
      },
      -- statusline
      sections = {
        lualine_a = {
          -- vim logo
          {
            function()
              return ""
            end
          },
          -- extra symbols for submodes (eg. visual line)
          {
            function()
              local symbol = {
                V = "LINE",          -- visual line
                [""] = "BLOCK",     -- visual block
                s = "SELECT"         -- select
              }
              -- return symbol table according to current mode or empty string if nil
              return symbol[vim.fn.mode()] or ""
            end
          },
          -- snippet indicator
          {
            function() return require("luasnip").in_snippet() and "" or "" end
          },
          -- notification indicator
          {
            function()
              local nvim_notify = require("notify")
              if nvim_notify.notification_is_supressed then
                local indicator = ""
                if #nvim_notify.supressed_notifications ~= 0 then
                  indicator = indicator .. " " .. #nvim_notify.supressed_notifications
                end
                return indicator
              end
              return "󰂚"
            end,
            on_click = function()
              require("notify").toggle_notification_supress()
              require("lualine").refresh({ place = { "statusline" } })
            end
          },
        },
        lualine_c = {
          {
            "filename",
            newfile_status = true,
            path = 1,     --relative path
            symbols = {
              modified = "●",
              readonly = "[RO]"
            }
          }
        }
      },
      -- winbar
      winbar = {
        lualine_c = {
          {
            function()
              local navic_location = require("nvim-navic").get_location()
              local filename = vim.fn.expand("%:t")
              local filetype_icon, filetype_icon_color = require("nvim-web-devicons").get_icon(filename)

              return "%#" ..
                  filetype_icon_color ..
                  "#" .. filetype_icon .. " %#NavicText#" .. filename .. "%#NavicSeparator#  " .. navic_location
            end,
            cond = function()
              return require("nvim-navic").is_available()
            end,
          },
        },
      },
      -- tabline
      tabline = {
        lualine_a = {
          {
            "tabs",
            max_length = vim.o.columns,
            mode = 1,
            fmt = function(name, context)
              local buflist = vim.fn.tabpagebuflist(context.tabnr)
              local winnr = vim.fn.tabpagewinnr(context.tabnr)
              local bufnr = buflist[winnr]

              local is_modified = vim.fn.getbufvar(bufnr, "&modified")

              local filetype_icon = require("nvim-web-devicons").get_icon(name)

              return (filetype_icon or "") .. " " .. name .. (is_modified == 1 and " ●" or "")
            end,
          }
        }
      },
    })
  end,
}
