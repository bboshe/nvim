require("binds.window")

vim.g.mapleader = " "

-- Editor ---------------------------------------------------------------------

vim.o.tabstop     = 4
vim.o.shiftwidth  = 4
vim.o.softtabstop = 4
vim.o.expandtab   = true


-- r       Automatically insert the current comment leader after hitting <Enter> in Insert mode.
-- c       Auto-wrap comments using textwidth, inserting the current comment leader automatically.
-- o       Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
vim.o.formatoptions = vim.o.formatoptions:gsub("r", ""):gsub("o", "")



-- Windows --------------------------------------------------------------------
win_prefix = '<leader>w'

vim.o.splitright = true
vim.o.splitbelow = true

vim.keymap.set('n', win_prefix         , '<C-w>'              , { })
vim.keymap.set('n', win_prefix..'r'    , window_resize_mode   , {noremap = true, silent = true})
vim.keymap.set('n', win_prefix..'<C-r>', window_resize_mode   , {noremap = true, silent = true})
vim.keymap.set('n', win_prefix..'v'    , ':vertical new<CR>'  , { })
vim.keymap.set('n', win_prefix..'s'    , ':horizontal new<CR>', { })

vim.keymap.set('n', '<leader>pn', float_window.create, { })





