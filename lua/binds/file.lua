return {
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
