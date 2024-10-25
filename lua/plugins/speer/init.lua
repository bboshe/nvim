return {
    "speer.nvim",
    dev = true,
    config = function()
        require("speer").setup({ })
        require("plugins.speer.binds")
    end,
    dependencies = {
        {
            "akinsho/bufferline.nvim",
            version = "*",
            dependencies = "nvim-tree/nvim-web-devicons",
            config = function()
                vim.opt.termguicolors = true
                require("bufferline").setup({
                    options = {
                        indicator = { style = "underline" }
                    }
                })
            end
        }
    }
}
