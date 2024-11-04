vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "windows.nvim"
  },
  config = function()
    local float = require("windows.float")
    local binds = require("binds.file").nvim_tree

    require("nvim-tree").setup{
     view = { float = {
          enable = true,
          open_win_config = function()
            return float.configure_window({
              width   = { rel = 0.5, min = 60, max = 200 },
              height  = { rel = 0.7, min = 10, max = 999 },
            })
          end,
      }, },
      actions = { open_file = { window_picker = {
            enable = false,
      } } },
      on_attach = binds.on_attach,    
    }

    binds.setup()
  end

}
