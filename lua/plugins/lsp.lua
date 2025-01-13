return {
    {
        "williamboman/mason.nvim",
        opts = {}
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup {}

            vim.diagnostic.config({
              sign = false, -- does not seem to work
              update_in_insert = true,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    vim.api.nvim_buf_set_option(ev.buf, "signcolumn", "no")

                    vim.keymap.set('n', '<leader>lF', vim.lsp.buf.format, { buffer = ev.buf })
                end,
            })
        end
    },
    {
        enabled = false,
        "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = function()
            -- Disable virtual_text since it's redundant due to lsp_lines.
            vim.diagnostic.config({
              virtual_text = false,
            })

            require("lsp_lines").setup()
        end
    },
}
