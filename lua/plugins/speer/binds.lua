local speer = require("speer")

local v_count = function()
    local count = vim.v.count
    if count == 0 then return nil else return count end
end

local add_keymap = function(key, func)
    vim.keymap.set('n', '<leader>j' .. key, func , { noremap = true, silent = true })
end


add_keymap('a', function() speer.goto_alternate() end)

add_keymap('d', function() speer.close_buffer({id=v_count()}) end)
add_keymap('D', function() speer.close_buffer({id=v_count(), force=true}) end)

add_keymap('c', function() speer.close_all({}) end)
add_keymap('C', function() speer.close_all({force=true}) end)

for i = 1, 9, 1 do
    add_keymap(tostring(i), function() speer.goto_buffer(i) end)
end




