return {
  "rcarriga/nvim-notify",     -- notification
  config = function()
    local nvim_notify = require("notify")
    nvim_notify.setup({
      background_colour = "#00000000",
      max_width = 50,
    })
    vim.notify = nvim_notify     -- implement

    -- suppress notifications [[
    nvim_notify.notification_is_supressed = false
    nvim_notify.supressed_notifications = {}

    nvim_notify.insert_supressed_notifications = function(msg, level, opts)
      local local_supressed_notifications = nvim_notify.supressed_notifications
      table.insert(local_supressed_notifications, {
        msg = msg,
        level = level,
        opts = opts
      })
      nvim_notify.supressed_notifications = local_supressed_notifications
    end

    nvim_notify.toggle_notification_supress = function()
      if nvim_notify.notification_is_supressed then
        vim.notify = nvim_notify
        for _, notification in pairs(nvim_notify.supressed_notifications) do
          vim.notify(notification.msg, notification.level, notification.opts)
        end
        nvim_notify.supressed_notifications = {}
      else
        vim.notify = nvim_notify.insert_supressed_notifications
      end
      nvim_notify.notification_is_supressed = not nvim_notify.notification_is_supressed
    end

    vim.keymap.set("n", "<Leader>ns", function()
      nvim_notify.toggle_notification_supress()
      require("lualine").refresh({ place = { "statusline" } })
    end)
    -- ]]

    -- dismiss all notifications
    vim.keymap.set("n", "<Leader>nd", function()
      nvim_notify.dismiss()
    end)
  end,
}
