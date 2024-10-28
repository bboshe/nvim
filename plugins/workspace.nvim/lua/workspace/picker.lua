local pickers = require "telescope.pickers"
local finders = require "telescope.finders"
local conf = require("telescope.config").values
local theme = require("telescope.themes").get_dropdown{}
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local entry_display = require "telescope.pickers.entry_display"

local function get_workspace_name(path)
    return path:match("([^\\/]+)[\\/]?$")
end

local function workspace_comparator(ws0, ws1)
    return ws0.last > ws1.last
end

local function gen_entry_maker()
    local displayer = entry_display.create {
        separator = " ",
        items = {
            { width = 20 },
            { remaining = true },
        },
    }
    local function make_display(entry)
        local ws_path = entry.value.workspace_path.filename;
        return displayer{
            get_workspace_name(ws_path),
            { ws_path, "TelescopeResultsComment" },
        }
    end
    return function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.workspace_path.filename,
        }
    end

end


return function(workspaces)
    table.sort(workspaces, workspace_comparator)
    pickers.new(theme, {
        prompt_title = "Workspaces",
        finder = finders.new_table {
            results = workspaces,
            entry_maker = gen_entry_maker()
        },
        attach_mappings = function(prompt_bufnr, _)
            actions.select_default:replace(function()
                actions.close(prompt_bufnr)
                local entry = action_state.get_selected_entry()
                local workspace = entry.value
                workspace:load()
            end)
            return true
        end,
        sorter = conf.generic_sorter(opts),
        initial_mode = "normal",
    }):find()
end

