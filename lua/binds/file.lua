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
      add_keymap("L"     , util.expand_node_window, "Edit Or Open")
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

  oil = {
    keymaps = {
      ["?"]     =   "actions.show_help",
      ["<CR>"]  =   "actions.select",
      ["ö"]     =   "actions.select",
      ["Ö"]     =   "actions.parent",
      -- ["<M-s>"] = { "actions.select", 
      --   opts = { vertical = true }, 
      --   desc = "Open the entry in a vertical split"
      -- },
      -- ["<M-h>"] = { "actions.select", 
      --   opts = { horizontal = true }, 
      --   desc = "Open the entry in a horizontal split"
      -- },
      ["ä"]     =   "actions.preview",
      ["Ä"]     =   "actions.toggle_hidden",
      ["<ESC>"] =   "actions.close",
      ["<M-r>"] =   "actions.refresh",
      -- ["."]     =   "actions.open_cwd",
      -- [":"]     =   "actions.cd",
      ["<M-o>"] =   "actions.change_sort",
      ["<C-Enter>"] = "actions.open_external",
      ["<M-t>"] =   "actions.toggle_trash",
    },
    setup = function(oil)
      local function open_float_cwd() 
        oil.open_float(vim.fn.getcwd()) 
      end

      vim.keymap.set('n', '<leader>ee', oil.open_float)
      vim.keymap.set('n', '<leader>ew', open_float_cwd)
    end
  }
}
