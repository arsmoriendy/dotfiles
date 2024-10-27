return {
  "rcarriga/nvim-notify", -- notification
  config = function()
    ---@type table
    local notify = require("notify")
    notify.setup({
      background_colour = "#00000000",
      minimum_width = 0,
      max_width = 50,
      render = "wrapped-compact",
      stages = "slide",
    })
    vim.notify = notify -- implement

    -- suppress notifications [
    notify.notification_is_supressed = false
    notify.supressed_notifications = {}

    notify.append_supressed_notifications = function(msg, level, opts)
      local local_supressed_notifications = notify.supressed_notifications
      table.insert(local_supressed_notifications, {
        msg = msg,
        level = level,
        opts = opts,
      })
      notify.supressed_notifications = local_supressed_notifications
    end

    notify.toggle_notification_supress = function()
      if notify.notification_is_supressed then
        vim.notify = notify
        for _, notification in pairs(notify.supressed_notifications) do
          vim.notify(notification.msg, notification.level, notification.opts)
        end
        notify.supressed_notifications = {}
      else
        vim.notify = notify.append_supressed_notifications
      end
      notify.notification_is_supressed = not notify.notification_is_supressed
    end

    vim.keymap.set("n", "<Leader>ns", function()
      notify.toggle_notification_supress()
      require("lualine").refresh({ place = { "statusline" } })
    end)
    -- ]

    -- dismiss all notifications
    vim.keymap.set("n", "<Leader>nd", function()
      notify.dismiss()
    end)
  end,
}
