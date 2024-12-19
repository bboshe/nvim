local float = require("windows.float")
local api   = require("nvim-tree.api")

local util = { }

function util.close_node()
  local node = api.tree.get_node_under_cursor()
  if node.type == 'directory' and node.open then
    api.node.open.edit(node)
  else
    api.node.navigate.parent_close(node)
  end
end

function util.expand_node(opener)
  local node = api.tree.get_node_under_cursor()
  if node.type == 'directory' then 
    if not node.open then
        api.node.open.edit(node)
    end
    api.node.navigate.sibling.first(node.nodes[1])
  else
    opener(node)
    api.tree.close()
  end
end

function util.expand_node_window()
    util.expand_node(function(node) 
      api.node.open.edit(node)
    end)
end

function util.expand_node_float()
    util.expand_node(function(node) 
      float.open_file(node.absolute_path, {
--        width  = { rel = 0.8, min = 80, max = 120 },
--        height = { rel = 0.9, min = 30, max = 999 }
      })
    end)
end

return util
