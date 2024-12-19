return {
  telescope = {
    setup = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
      vim.keymap.set('n', '<leader>fg', builtin.live_grep , {})
    end
  },

  nvim_tree = {
    on_attach = function (bufnr)
      local api  = require("nvim-tree.api")
      local util = require("plugins.nvimtree.util")

      api.config.mappings.default_on_attach(bufnr)

      local function add_keymap(key, func, desc)
        vim.keymap.set('n', key, func, 
          { desc = "nvim-tree: " .. desc, buffer = bufnr, 
            noremap = true, silent = true, nowait = true })
      end

      add_keymap('?'     , api.tree.toggle_help,    'Help')
      add_keymap('<ESC>' , api.tree.close,          'Close')
      add_keymap("l"     , util.expand_node_float,  "Edit Or Peak")
      add_keymap("<CR>"  , util.expand_node_float,  "Edit Or Peak")
      add_keymap("<leader><CR>"   , util.expand_node_window, "Edit Or Open")
      add_keymap("h"     , util.close_node,         "Close Directory")
      add_keymap("H"     , api.tree.collapse_all,   "Collapse All")
    end,

    setup = function()
      local api = require("nvim-tree.api")

      vim.keymap.set("n", "<leader>e", function()
        api.tree.open({ find_file = true })
      end, {})
    end
  },
}
