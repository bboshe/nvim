return {
    "windows.nvim",
    dev = true,
    config = function()
        local windows = require("windows")

        windows.setup({})

        vim.keymap.set('n', ' <ESC>', windows.float.reopen, { })
        -- vim.keymap.set('n', '<ESC>', windows.float.close, { })

    end
}

