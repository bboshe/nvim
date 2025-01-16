return {
    telescope = {
        keys = {
            launch_find    = '<leader>ff',
            launch_grep    = '<leader>fg',
            launch_buffers = '<leader>fb',
            launch_help    = '<leader>fh',
            edit           = '<TAB>',
            edit_float     = '<CR>',
        },
    },
    nvimtree = {
        float = {
            width  = { rel = 0.5, min = 60, max = 200 },
            height = { rel = 0.7, min = 10, max = 999 },
        },
        keys = {
            launch_float   = '<leader>e',
            close          = '<ESC>',
            expand         = 'l',
            collapse       = 'h',
            collapse_all   = 'H',
            edit           = 'L',
            edit_alt       = '<TAB>',
            edit_float     = 'l',
            edit_float_alt = '<CR>',
            help           = '?',
        },
    },
    barbar = {
        keys = {
            leader     = 'd', -- prefix for all buffer operations
            mode       = 'd', -- enter buffer navigation mode
            prev       = 'h',
            next       = 'l',
            first      = 'j',
            last       = 'k',
            pick       = 'f',
            move_prev  = 'H',
            move_next  = 'L',
            move_first = 'J',
            pick_close = 'F',
            close      = 'c',
            pin        = 'p',
            restore    = 'r',
        },
    },
    language = {
        keys = {
            code_action = '<C-.>',
            format = '<leader>lf',
        },
        pylsp = {
            plugins = {
                pycodestyle = {
                    maxLineLength = 200,
                },
            }
        },
        lua_ls = {
            runtime = {
                version = "LuaJIT",
                path = vim.split(package.path, ";"),
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = { vim.env.VIMRUNTIME },
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },

        }
    },
    autocmp = {
        keys = {
            trigger   = '<C-,',
            confirm   = '<CR>',
            docs_up   = '<PageUp>',
            docs_down = '<PageDown>',
        },
    },
}
