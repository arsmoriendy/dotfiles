local cau = vim.api.nvim_create_autocmd
local lib = require("lib")
local kms = lib.kms

cau("FileType", {
  desc = "Enable ConTeXt keymaps",
  pattern = "context",
  callback = function()
    vim.notify("Using ConTeXt keymaps")

    local compile = function()
      vim.cmd("!context %")
    end

    kms("n", "<F5>", function()
      vim.cmd("write")
      compile()
    end, "Save and Compile ConTeXt file")
  end
})
