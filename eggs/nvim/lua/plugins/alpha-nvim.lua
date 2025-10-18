return {
  "goolord/alpha-nvim", -- startup splash screen
  enabled = false,
  config = function()
    -- highlights
    vim.cmd([[
      highlight AlphaLogo guifg=#504945
      highlight AlphaText guifg=#665C54
      highlight AlphaTextItalic guifg=#665C54 gui=italic
      highlight AlphaTextBold guifg=#665C54 gui=bold
      highlight AlphaTextBoldItalic guifg=#665C54 gui=bold,italic
      ]])

    -- header
    local header = {
      type = "text",
      val = {
        [[     ▗▛                                            ▜▖     ]],
        [[    ▟▛                                              ▜▙    ]],
        [[   ▟▛               ▗▟█████▄▄▄▄█████▙▖               ▜▙   ]],
        [[  ▟█              ▗▟██████████████████▙▖              █▙  ]],
        [[ ▐██             ▟██████████████████████▙             ██▌ ]],
        [[  ██▙          ▗▟████████████████████████▙▖          ▟██  ]],
        [[  ▐███▙▂▂   ▂▂▟████████████████████████████▙▂▂   ▂▂▟███▌  ]],
        [[    ▜████████████████████████████████████████████████▛    ]],
        [[      ▀▀▀▀██████████████████████████████████████▀▀▀▀      ]],
        [[              ▀▀▀▀▀██   ▝▜██████▛▘   ██▀▀▀▀▀              ]],
        [[                    ▜▙    ██████    ▟▛                    ]],
        [[                     ▜██▆▆██████▆▆██▛                     ]],
        [[                      ▜████████████▛                      ]],
        [[                       ▜██████████▛                       ]],
        [[                        ▜████████▛                        ]],
        [[                        ██████████                        ]],
        [[                         ▜█▅██▅█▛                         ]],
      },
      opts = {
        position = "center",
        hl = "AlphaLogo",
      },
    }

    -- subheader
    local subheader = {
      type = "text",
      val = function()
        -- neovim version
        local nvim_version_table = vim.version()
        -- if version is under 15
        -- convert version decimal to hex for 1 digit numbers
        -- else replace with "X" as placeholder
        local parsed_major = nvim_version_table.major <= 15
            and string.upper(string.format("%x ", nvim_version_table.major))
          or " X"
        local parsed_minor = nvim_version_table.minor <= 15
            and string.upper(string.format("%x ", nvim_version_table.minor))
          or " X"
        local parsed_patch = nvim_version_table.patch <= 15
            and string.upper(string.format("%x ", nvim_version_table.patch))
          or " X"

        local lazy_stats = require("lazy").stats()

        -- redraw alpha when lazy has finished calculating startuptime
        vim.api.nvim_create_autocmd("User", {
          pattern = "LazyVimStarted",
          command = "AlphaRedraw",
        })

        return {
          "NEOVIM INFORMATION        + + + + +",
          "------------------------- + N E O +",
          string.format(
            "%-28s",
            " v" .. nvim_version_table.major .. "." .. nvim_version_table.minor .. "." .. nvim_version_table.patch
          ) .. "+ V I M +",
          string.format("%-29s", "󰒲 " .. lazy_stats.count .. " plugins installed")
            .. "+ "
            .. parsed_major
            .. parsed_minor
            .. parsed_patch
            .. "+",
          string.format("%-29s", "󰀠 " .. string.format("%.2f", lazy_stats.startuptime) .. "ms startuptime")
            .. "+ + + + +",
        }
      end,
      opts = {
        position = "center",
        hl = "AlphaTextBold",
      },
    }

    -- button factory
    local button = function(val, action)
      local shortcut = string.lower(string.sub(val, 1, 1))
      local shortcut_string = "[" .. shortcut .. "]"

      return {
        type = "button",
        val = val,
        on_press = function()
          vim.api.nvim_input(action)
        end,
        opts = {
          position = "center",
          width = 35,
          hl = "AlphaTextBold",
          shortcut = shortcut_string,
          align_shortcut = "right",
          hl_shortcut = "AlphaTextBold",
          keymap = { "n", shortcut, action, { silent = true } },
        },
      }
    end

    -- button group
    local buttonGroup = {
      type = "group",
      val = {
        button("New File", ":enew <CR>"),
        button("Plugins Profile", ":Lazy profile<CR>"),
        button("Check Plugins", ":Lazy check<CR>"),
        button("Update Plugins", ":Lazy update<CR>"),
        button("Quit", ":q <CR>"),
      },
      opts = {
        spacing = 1,
      },
    }

    local theme = {
      layout = {
        { type = "padding", val = 8 },
        header,
        { type = "padding", val = 2 },
        subheader,
        { type = "padding", val = 2 },
        {
          type = "text",
          val = {
            "ACTIONS",
            "-----------------------------------",
          },
          opts = {
            position = "center",
            hl = "AlphaTextBold",
          },
        },
        buttonGroup,
        { type = "padding", val = 10 },
      },
    }

    require("alpha").setup(theme)
  end,
}
