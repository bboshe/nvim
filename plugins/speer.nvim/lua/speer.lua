local M = {}

M.bufferline = nil
M.buffer_table = {}
M.buffer_sort = {}

M.buf_get_win = function(buf)
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        if buf == vim.api.nvim_win_get_buf(win) then
            return win
        end
    end
end

M.buf_is_hidden = function(buf)
    return vim.api.nvim_get_option_value('bufhidden', { buf = buf })
end

M.buf_is_modified = function (buf)
    return vim.api.nvim_get_option_value('modified', { buf = buf })
end

M.print_buffers = function()
    local message = { "Speer Buffers:\n" }
    for _, info in pairs(M.buffer_sort) do
        table.insert(message, string.format("% 4d % 3d : %s '%s'\n", info.count, info.buf, info.file, info.type))
    end
    vim.notify(table.concat(message))
end

M.update_buffers = function()
    local new_buffer_table = {}
    for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local file = vim.api.nvim_buf_get_name(buf)
        local type_  = vim.api.nvim_get_option_value('buftype'  , {buf=buf})
        local listed = vim.api.nvim_get_option_value('buflisted', {buf=buf})
        local hidden = vim.api.nvim_get_option_value('bufhidden', {buf=buf})
        if listed and type_ == "" then
            local old_data = M.buffer_table[buf]
            new_buffer_table[buf] = {
                buf = buf,
                file = file,
                type = type_,
                listed = listed,
                hidden = hidden,
                count = old_data and old_data.count or 0
            }
        end
    end
    M.buffer_table = new_buffer_table
end

M.sort_buffers = function()
    local sorted_buffers = {}
    for _, buf_info in pairs(M.buffer_table) do
        table.insert(sorted_buffers, buf_info)
    end
    table.sort(sorted_buffers, function (left, right)
        return left.count > right.count
    end)
    M.buffer_sort = sorted_buffers
end

M.get_buffer_info = function(buf)
    return M.buffer_table[buf]
end

M.get_buffer_index = function (buf)
    for i, buf_info in ipairs(M.buffer_sort) do
        if buf_info.buf == buf then
            return i
        end
    end
    return nil
end

M.increment_buffer = function()
    local buf = vim.api.nvim_win_get_buf(0)
    local buf_info = M.get_buffer_info(buf)
    if buf_info ~= nil then
        buf_info.count = buf_info.count + 1
    end
end

M.on_buff_enter = function()
    M.update_buffers()
    M.increment_buffer()
    M.sort_buffers()
end

M.on_buff_delete = function()
    local del_buf = tonumber( vim.fn.expand('<abuf>'))
    if del_buf then
        M.buffer_table[del_buf] = nil
        M.sort_buffers()
    end
end

M.get_buffer_by_id = function(id)
    local index = tonumber(id)
    if index then
        return M.buffer_sort[index]
    end
    return nil
end

M.goto_buffer = function(id)
    vim.api.nvim_win_set_buf(0, M.get_buffer_by_id(id).buf)
end

M.goto_alternate = function()
    local alt_buf = vim.fn.bufnr('#')
    vim.api.nvim_win_set_buf(0, alt_buf)
end

M.close_buffer = function(opts)
    vim.notify("close index " .. tostring(opts.id))
    local current_buf = opts.id and M.get_buffer_by_id(opts.id).buf or opts.buf or vim.api.nvim_win_get_buf(0)
    vim.notify("close buffer "..tostring(current_buf))
    local modified = vim.api.nvim_get_option_value('modified', { buf = current_buf })
    if modified and not opts.force then
        local name = vim.api.nvim_buf_get_name(current_buf)
        name = name ~= "" and name or "[No Name]"
        vim.notify(string.format("Can not delete modified buffer '%s'", name), vim.log.levels.ERROR)
        return
    end

    local current_window = M.buf_get_win(current_buf)
    if current_window then
        local last_buf = vim.fn.bufnr('#')
        if last_buf ~= -1 and not M.buf_is_hidden(last_buf) then
            last_buf = -1
        end
        if last_buf == -1 then
            for _, buf_info in ipairs(M.buffer_sort) do
                if M.buf_is_hidden(buf_info.buf) and buf_info.buf ~= current_buf then
                   last_buf = buf_info.buf
        end end end
        if last_buf == -1 then
            last_buf = vim.api.nvim_create_buf(false, true)
        end
        vim.api.nvim_win_set_buf(current_window, last_buf)
    end

    if M.buf_is_hidden(current_buf) then
        vim.api.nvim_buf_delete(current_buf, { force = opts.force or false })
    end
end

M.close_all = function(opts)
    for _, buffer in ipairs(vim.api.nvim_list_bufs()) do
        if (opts.force or not M.buf_is_modified(buffer)) then
            M.close_buffer({ buf = buffer, force = opts.force })
        end
    end
end



M.setup = function(config)
    M.bufferline = require("bufferline")
    M.bufferline.setup(M.create_bufferline_config(config.bufferline))

    local GROUP_NAME = "Speer"
    vim.api.nvim_create_augroup(GROUP_NAME, { clear = true })
    vim.api.nvim_create_autocmd("BufEnter" , { group = GROUP_NAME, callback = M.on_buff_enter })
    vim.api.nvim_create_autocmd("BufDelete", { group = GROUP_NAME, callback = M.on_buff_delete })

    vim.api.nvim_create_user_command('SpeerList' , function(_)
        M.print_buffers()
    end, {})

    vim.api.nvim_create_user_command('SpeerGoto' , function(opts)
        M.goto_buffer(opts.fargs[1])
    end, { nargs = 1 })

    vim.api.nvim_create_user_command('SpeerClose', function(opts)
        M.close_buffer({ id = opts.fargs[1], force = opts.bang })
    end, { nargs = 1, bang = true})

    vim.api.nvim_create_user_command('SpeerClose', function(opts)
        M.close_buffer({ force = opts.bang })
    end, { bang = true })
end


M.create_bufferline_config = function(config)
    if config == nil then
        config = {}
    end

    config.mode = "buffers"
    config.show_buffer_close_icons = false
    config.persist_buffer_sort = false

    config.numbers = function(tab)
        local name = tostring(M.get_buffer_index(tab.id))
        local hidden = vim.api.nvim_get_option_value('bufhidden', {buf=tab.id})
        if not hidden then
            name = tab.raise(name)
        end
        return name
    end

    config.custom_filter = function(buf_number, _)
        local index = M.get_buffer_index(buf_number)
        if not index then return false end
        if index > 9 then return false end
        -- if buf_info.count == 0 then return false end
        return true
    end

    config.sort_by = function(buffer_a, buffer_b)
        local buf_info_a = M.get_buffer_info(buffer_a.id)
        local buf_info_b = M.get_buffer_info(buffer_b.id)
        return buf_info_a.count > buf_info_b.count
    end

    return { options = config }
end

-- for hot reloading with :so%
-- M.setup({})
-- M.on_buff_enter()

return M
