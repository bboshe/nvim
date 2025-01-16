return {
    {
        "williamboman/mason.nvim",
        opts = {}
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "pylsp",
                }
            })
        end
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            local cfg = require("config").language
            local lspconfig = require("lspconfig")

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lspconfig.lua_ls.setup {
                settings = { Lua = cfg.lua_ls },
                capabilities = capabilities,
            }

            lspconfig.pylsp.setup {
                settings = { pylsp = cfg.pylsp },
                capabilities = capabilities,
            }

            vim.diagnostic.config({
                sign = false, -- does not seem to work
                update_in_insert = true,
            })

            vim.api.nvim_create_autocmd('LspAttach', {
                callback = function(ev)
                    vim.api.nvim_buf_set_option(ev.buf, "signcolumn", "no")

                    local function add(key, func)
                        vim.keymap.set('n', key, func, { buffer = ev.buf })
                    end

                    add(cfg.keys.format, vim.lsp.buf.format)
                    add(cfg.keys.code_action, vim.lsp.buf.code_action)
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
    {
        "hrsh7th/nvim-cmp",
        config = function()
            local cfg = require("config").autocmp
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                },
                window = {
                    -- completion = cmp.config.window.bordered(),
                    -- documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    [cfg.keys.trigger] = cmp.mapping.complete(),
                    [cfg.keys.confirm] = cmp.mapping.confirm({ select = true }),
                    -- ['<Left>'] = cmp.mapping.abort(),
                    [cfg.keys.docs_up] = cmp.mapping.scroll_docs(-4),
                    [cfg.keys.docs_down] = cmp.mapping.scroll_docs(4),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                }, {
                    { name = 'buffer' },
                    { name = 'path' },
                })
            })
        end
    }
}
