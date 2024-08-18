return {
  "mfussenegger/nvim-dap",
  event = "VeryLazy",
  config = function()
    local dap = require("dap")
    local lib = require("lib")

    -- adapters configurations {
    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }
    -- }

    -- debugee configurations {

    -- WARNING: make sure to run from an absolute path (when debugging go using delve)
    dap.configurations.go = {
      {
        type = "go",
        request = "launch",
        name = "Test",
        mode = "test",
        program = function()
          return coroutine.create(function(dap_run_co)
            local res = vim.system({ "go", "list", "./..." }):wait()

            if res.code ~= 0 then
              vim.notify(res.stderr, vim.log.levels, {
                title = "Failed retrieving go packages" })
              return
            end

            local items = vim.split(res.stdout, "\n")

            vim.ui.select(items, { prompt = "Select debugee" },
              function(item, idx)
                if idx == nil then
                  return
                end
                coroutine.resume(dap_run_co, item)
              end)
          end)
        end,
      },
    }
    -- }

    -- keymaps {
    local kms = lib.kms
    kms("n", "<F5>", dap.continue, "(DAP) Continue")
    kms("n", "<F10>", dap.step_over, "(DAP) Step Over")
    kms("n", "<F11>", dap.step_into, "(DAP) Step Into")
    kms("n", "<F12>", dap.step_out, "(DAP) Step Out")
    kms("n", "<Leader>b", dap.toggle_breakpoint, "(DAP) Toggle Breakpoint")
    kms("n", "<Leader>Dr", dap.repl.toggle, "(DAP) Toggle REPL")
    -- }
  end
}
