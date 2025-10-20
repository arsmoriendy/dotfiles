local M = {}

-- stylua: ignore start
--- Wether or not to skip splash screen
--- Copied from https://github.com/goolord/alpha-nvim/blob/2b3cbcdd980cae1e022409289245053f62fb50f6/lua/alpha.lua#L570C1-L610C4
function M.skip_splash()
    -- don't start when opening a file
    if vim.fn.argc() > 0 then return true end

    -- Do not open alpha if the current buffer has any lines (something opened explicitly).
    local lines = vim.api.nvim_buf_get_lines(0, 0, 2, false)
    if #lines > 1 or (#lines == 1 and lines[1]:len() > 0) then return true end

    -- Skip when there are several listed buffers.
    for _, buf_id in pairs(vim.api.nvim_list_bufs()) do
        local bufinfo = vim.fn.getbufinfo(buf_id)
        if bufinfo.listed == 1 and #bufinfo.windows > 0
            then return true
        end
    end

    -- Handle nvim -M
    if not vim.o.modifiable then return true end

    ---@diagnostic disable-next-line: undefined-field
    for _, arg in pairs(vim.v.argv) do
        -- whitelisted arguments
        -- always open
        if arg == "--startuptime"
        then return false
        end

        -- blacklisted arguments
        -- always skip
        if arg == "-b"
            -- commands, typically used for scripting
            or arg == "-c" or vim.startswith(arg, "+")
            or arg == "-S"
        then return true
        end
    end

    -- base case: don't skip
    return false
end

return M
