return {
    "workspace.nvim",
    dev = true,
    config = function()
        require("workspace").setup({})
    end,
    dependencies = {
        {
            'nvim-telescope/telescope.nvim',
            branch = '0.1.x',
            dependencies = { 'nvim-lua/plenary.nvim' },
        }
    }
}



