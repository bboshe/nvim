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
    local cfg = require("config").nvimtree
    local float = require("windows.float")

    require("nvim-tree").setup{
     view = { float = {
          enable = true,
          open_win_config = function()
            return float.configure_window(cfg.float)
          end,
      }, },
      actions = { open_file = { window_picker = {
            enable = false,
      } } },
      on_attach = function (bufnr)
        local api  = require("nvim-tree.api")
        local util = require("plugins.nvimtree.util")

        api.config.mappings.default_on_attach(bufnr)

        local function add_keymap(key, func, desc)
          vim.keymap.set('n', key, func, 
            { desc = "nvim-tree: " .. desc, buffer = bufnr, 
              noremap = true, silent = true, nowait = true })
        end

        local k = cfg.keys
        add_keymap(k.help          , api.tree.toggle_help,    'Help')
        add_keymap(k.close         , api.tree.close,          'Close')
        add_keymap(k.edit_float    , util.expand_node_float,  "Edit Float")
        add_keymap(k.edit_float_alt, util.expand_node_float,  "Edit Float")
        add_keymap(k.edit          , util.expand_node_window, "Edit")
        add_keymap(k.edit_alt      , util.expand_node_window, "Edit")
        add_keymap(k.collapse      , util.close_node,         "Collapse Node")
        add_keymap(k.collapse_all  , api.tree.collapse_all,   "Collapse All")
      end,
    }

    local api = require("nvim-tree.api")

    vim.keymap.set("n", cfg.keys.launch_float, function()
      api.tree.open({ find_file = true })
    end, {})
  end

}
