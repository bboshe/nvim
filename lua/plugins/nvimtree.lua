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

    require("nvim-tree").setup{
     view = {
        float = {
          enable = true,
          open_win_config = function()
            return float.configure_window({
              width   = { rel = 0.5, min = 60, max = 200 },
              height  = { rel = 0.7, min = 10, max = 999 },
            })
          end,
        },
      },

      on_attach = function (bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, 
                   noremap = true, silent = true, nowait = true }
        end

        local function close_node()
          local node = api.tree.get_node_under_cursor()
          if node.type == 'directory' and node.open then
            api.node.open.edit(node)
          else
            api.node.navigate.parent_close(node)
          end
        end

        local function edit_or_open()
          local node = api.tree.get_node_under_cursor()
          if node.type == 'directory' then 
            if not node.open then
                api.node.open.edit(node)
            end
            api.node.navigate.sibling.first(node.nodes[1])
          else
            print(vim.inspect(node, {depth=1}))
            -- api.node.open.edit(node)
            float.open_file(node.absolute_path)
            api.tree.close()
          end
        end

        api.config.mappings.default_on_attach(bufnr)

        vim.keymap.set('n', '?'    , api.tree.toggle_help,  opts('Help'))
        vim.keymap.set('n', '<ESC>', api.tree.close,        opts('Close'))
        vim.keymap.set("n", "l"    , edit_or_open,          opts("Edit Or Open"))
        vim.keymap.set("n", "h"    , close_node,            opts("Close Directory"))
        vim.keymap.set("n", "H"    , api.tree.collapse_all, opts("Collapse All"))
      end
    }

    local api = require("nvim-tree.api")
    vim.keymap.set("n", "<leader>e", ":NvimTreeOpen<CR><ESC>", {})
  end

}
