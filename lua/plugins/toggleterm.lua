return {
    'akinsho/toggleterm.nvim', 
    version = "*", 
    config = function()
        require("toggleterm").setup()

        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
          vim.keymap.set('t', '<C-h>', [[<Left>]], opts)
          vim.keymap.set('t', '<C-j>', [[]], opts)
          vim.keymap.set('t', '<C-k>', [[]], opts)
          vim.keymap.set('t', '<C-l>', [[]], opts)
          vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
        end

        -- if you only want these mappings for toggle term use term://*toggleterm#* instead
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
}

