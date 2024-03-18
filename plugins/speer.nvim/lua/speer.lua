local M = {}

M.config = {
}


M.file_refs = {}

M.print_ref_count = function()
    local message = { "Speer Buffers:\n" }
    for i, ref in ipairs(M.file_refs) do
        table.insert(message, string.format("% 4d %d : %s\n", ref.count, i, ref.file))
    end
    vim.notify(table.concat(message))
end

M.get_ref = function(file)
    for i, ref in pairs(M.file_refs) do
        if ref.file == file then
            return i, ref
        end
    end
    local ref = {file = file, count = 0}
    table.insert(M.file_refs, ref)
    return #M.file_refs, ref
end

M.remove_ref = function (file)
    local i, _ = M.get_ref(file)
    table.remove(M.file_refs, i)
end

M.add_ref = function(file)
    local _, ref = M.get_ref(file)
    ref.count = ref.count + 1
    M.sort_refs()
end

M.sort_refs = function ()
    table.sort(M.file_refs, function(left, right)
        return left.count < right.count
    end)
end


M.buf_filter = function(buf, file)
    return buf ~= nil and file ~= ""
    -- TODO fiiler non files
end


M.on_buff_enter = function()
    local buf = vim.api.nvim_win_get_buf(0)
    local file = vim.api.nvim_buf_get_name(buf)
    if not M.buf_filter(buf, file) then
        return
    end

    M.add_ref(file)

    -- M.print_ref_count()
end

M.on_buff_delete = function()
    local buf = vim.api.nvim_win_get_buf(0)
    local file = vim.api.nvim_buf_get_name(buf)

    print("delte fuffer ", file)
    M.remove_ref(file)
end


M.setup = function(config)
    print("setup here")
    require("bufferline").setup(M.create_bufferline_config(config.bufferline))

    local GROUP_NAME = "Speer"
    vim.api.nvim_create_augroup(GROUP_NAME, { clear = true })
    vim.api.nvim_create_autocmd("BufEnter"  , { group = GROUP_NAME, callback = M.on_buff_enter  })
    vim.api.nvim_create_autocmd("BufDelete" , { group = GROUP_NAME, callback = M.on_buff_delete })

end


M.create_bufferline_config = function(config)
    if config == nil then
        config = {}
    end

    config.custom_filter = function(buf_number, _)
        local file = vim.api.nvim_buf_get_name(buf_number)

        local _, ref = M.get_ref(file)
        if ref.count == 0 then
            return
        end

        return true
    end

    config.sort_by = function(buffer_a, buffer_b)
        local _, refa = M.get_ref(buffer_a.path)
        local _, refb = M.get_ref(buffer_b.path)
        return refa.count > refb.count
    end

    return { options = config }
end

--M.setup({})

return M
