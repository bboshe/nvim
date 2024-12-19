return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
          require("binds.file").telescope.setup()
          require("binds.buffer").telescope.setup()
          local builtin = require("telescope.builtin")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")
          local float = require("windows.float")

          local peek_file = function(opts) 
            local entry = action_state.get_selected_entry()
            float.open_file(entry[1], { })
          end
          
            
          require("telescope").setup
          {
            pickers = { 
              find_files = {
              mappings = { 
              n = {
                 ["<CR>"] = peek_file,
                 ["<leader><CR>"] = actions.select_default
                }, 
              i = {
                ["<CR>"] = peek_file,
              },
             }, 
            }
            }
          }
            
          vim.keymap.set('n', '<leader>fh', builtin.help_tags , {})
        end
    },
    {
        'nvim-telescope/telescope-ui-select.nvim',
        config = function()
            require("telescope").setup {
              extensions = {
                ["ui-select"] = {
                  require("telescope.themes").get_dropdown {
                    -- even more opts
                  }

                  -- pseudo code / specification for writing custom displays, like the one
                  -- for "codeactions"
                  -- specific_opts = {
                  --   [kind] = {
                  --     make_indexed = function(items) -> indexed_items, width,
                  --     make_displayer = function(widths) -> displayer
                  --     make_display = function(displayer) -> function(e)
                  --     make_ordinal = function(e) -> string
                  --   },
                  --   -- for example to disable the custom builtin "codeactions" display
                  --      do the following
                  --   codeactions = false,
                  -- }
                }
              }
            }
            -- To get ui-select loaded and working with telescope, you need to call
            -- load_extension, somewhere after setup function:
            require("telescope").load_extension("ui-select")
        end
    }
}
