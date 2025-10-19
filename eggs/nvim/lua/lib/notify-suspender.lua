local lib = require("lib")
local kms = lib.kms

local M = {}

M.notification_is_supressed = false
M.supressed_notifications = {}

M.append_supressed_notifications = function(msg, level, opts)
  local local_supressed_notifications = M.supressed_notifications
  table.insert(local_supressed_notifications, {
    msg = msg,
    level = level,
    opts = opts,
  })
  M.supressed_notifications = local_supressed_notifications
end

M.toggle_notification_supress = function()
  if M.notification_is_supressed then
    vim.notify = require("snacks.notifier")
    for _, notification in ipairs(M.supressed_notifications) do
      vim.notify(notification.msg, notification.level, notification.opts)
    end
    M.supressed_notifications = {}
  else
    vim.notify = M.append_supressed_notifications
  end
  M.notification_is_supressed = not M.notification_is_supressed
end

kms("n", "<Leader>ns", function()
  M.toggle_notification_supress()
  require("lualine").refresh({ place = { "statusline" } })
end, "Suppress notifications")

return M
