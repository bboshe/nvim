require("binds.window")

-- require("binds.oil").setup()

vim.g.mapleader = " "

-- Editor ---------------------------------------------------------------------

vim.o.tabstop     = 4
vim.o.shiftwidth  = 4
vim.o.softtabstop = 4
vim.o.expandtab   = true

vim.o.number         = true
vim.o.relativenumber = true


-- r       Automatically insert the current comment leader after hitting <Enter> in Insert mode.
-- c       Auto-wrap comments using textwidth, inserting the current comment leader automatically.
-- o       Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
-- someone must override this???
vim.o.formatoptions = vim.o.formatoptions:gsub("r", ""):gsub("o", "")
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')


-- hilight current word
-- vim.keymap.set('n', 'md', 'gd', { })

vim.keymap.set('n', '<M-u>', '<C-u>', { })
vim.keymap.set('n', '<M-d>', '<C-d>', { })


-- Windows --------------------------------------------------------------------
local win_prefix = '<leader>w'

vim.o.splitright = true
vim.o.splitbelow = true

vim.keymap.set('n', win_prefix         , '<C-w>'              , { })
vim.keymap.set('n', win_prefix..'r'    , window_resize_mode   , { noremap = true, silent = true })
vim.keymap.set('n', win_prefix..'<C-r>', window_resize_mode   , { noremap = true, silent = true })
vim.keymap.set('n', win_prefix..'v'    , ':vertical new<CR>'  , { })
vim.keymap.set('n', win_prefix..'s'    , ':horizontal new<CR>', { })


vim.keymap.set('n', '<leader>pn',
    peak_window.create,
    { })

vim.keymap.set('n', '<leader>pt', function()
    peak_window.create()
    vim.cmd(':term')
    vim.api.nvim_feedkeys('i', 't', true)
end, { })


-- Other --------------------------------------------------------------------

local create_comman_open_help = function(name, peak)
    vim.api.nvim_create_user_command(name, function(opts)
        if peak then
            peak_window.create()
        end
        vim.cmd.enew()
        vim.cmd.set('buftype=help')
        vim.cmd.help({args=opts.fargs})
    end, {complete = 'help', nargs = 1})
end

create_comman_open_help('H' , false)
create_comman_open_help('HP', true)






