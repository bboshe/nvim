return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
          local telescope = require("telescope")
          local builtin = require("telescope.builtin")
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          local float = require("windows.float")
          local keys = require("config").telescope.keys

          local peek_file = function(opts) 
            local entry = action_state.get_selected_entry()
            float.open_file(entry[1], { })
          end
            
          telescope.setup
          {
            pickers = { 
              find_files = {
              mappings = { 
              n = {
                 [keys.edit]       = actions.select_default,
                 [keys.edit_float] = peek_file,
                }, 
              i = {
                 [keys.edit]       = actions.select_default,
                 [keys.edit_float] = peek_file,
              },
             }, 
            }
            }
          }
            
          vim.keymap.set('n', keys.launch_find   , builtin.find_files, {})
          vim.keymap.set('n', keys.launch_grep   , builtin.live_grep , {})
          vim.keymap.set('n', keys.launch_buffers, builtin.buffers   , {})
          vim.keymap.set('n', keys.launch_help   , builtin.help_tags , {})
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
