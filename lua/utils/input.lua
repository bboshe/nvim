local CHAR_ESC = '\27'

local input = {}

input.custom_mode = function(name, actions)
    vim.cmd('echo "' .. name .. '"')

    if actions[CHAR_ESC] == nil then
        actions[CHAR_ESC] = function() return true end
    end

    while true do
        local char = vim.fn.nr2char(vim.fn.getchar())

        local action = actions[char]
        if action ~= nil then
            if type(action) == "string" then
                vim.cmd(action)
            elseif type(action) == "function" then
                if action() then break end 
            elseif type(action) == "boolean" then
                if action then break end
            else
                error("unsupported action type")
            end
        end

        local universal_action = actions[1]
        if universal_action ~= nil then
            if universal_action(char) then break end
        end
    end
    vim.api.nvim_feedkeys(':', 'nx', true)
end

return input
