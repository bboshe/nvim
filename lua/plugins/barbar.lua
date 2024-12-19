return {
    'romgrk/barbar.nvim',
    dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function() 
        vim.g.barbar_auto_setup = false 
    end,
    opts = {
        animation = false,
        focus_on_close = 'previous',
        insert_at_start = true,
    },
    config = function(_, opts)
        -- Setup -----------------------------------------------------
        require('barbar').setup(opts)

        -- Keymaps ---------------------------------------------------
        local keys = require('config').buffer.keys

        local function keymap(key, cmd)
            vim.keymap.set(
                'n', 
                '<leader>'..keys.leader..key, 
                cmd, 
                { noremap = true, silent = true }
            )
        end

        local commands = {
            {key=keys.prev,       cmd='BufferPrevious',     mode=true},
            {key=keys.next,       cmd='BufferNext',         mode=true},
            {key=keys.first,      cmd='BufferFirst',        mode=true},
            {key=keys.last,       cmd='BufferLast',         mode=true},
            {key=keys.move_prev,  cmd='BufferMovePrevious', mode=true},
            {key=keys.move_next,  cmd='BufferMoveNext',     mode=true},
            {key=keys.move_first, cmd='BufferMoveStart',    mode=true},
            {key=keys.close     , cmd='BufferClose',        mode=true},
            {key=keys.pin       , cmd='BufferPin',          mode=true},
            {key=keys.restore   , cmd='BufferRestore',      mode=true},
            {key=keys.pick      , cmd='BufferPick'},
            {key=keys.pick_close, cmd='BufferPickDelete'},
        } 
        
        for _, command in ipairs(commands) do 
            -- vim.print(command)
            keymap(command.key, '<Cmd>'..command.cmd..'<CR>')
        end
        for i = 1, 9 do
            keymap(tostring(i), '<Cmd>BufferGoto '..tostring(i)..'<CR>')
        end
        
        -- Buffer Mode ----------------------------------------------
        local function make_action(cmd) 
            return function()
                vim.cmd(cmd)
                vim.cmd("redraw")
                return false
            end
        end

        local buffer_mode_actions = { ['\13'] = true }
        for _, command in ipairs(commands) do 
            if command.mode then
                buffer_mode_actions[command.key] = make_action(command.cmd)
            end
        end

        keymap(keys.mode, function(_) 
            require("utils.input").custom_mode("-- BUFFER --", buffer_mode_actions)
        end)

    end,
    version = '1.8.*', -- file names are bugged in v1.9.1
}
