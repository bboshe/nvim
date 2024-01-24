local M = {}


M.file_ref_count = {}
M.config = {
    count = 3,
}


M.reset_ref_count = function()
    M.file_ref_count = {}
end


M.print_ref_count = function()
    vim.notify(vim.inspect(M.file_ref_count))
--    for file, count in ipairs(M.file_ref_count) do 
--        print(file, count)
end

M.get_ref_count = function(buf_id)
    return M.file_ref_count[vim.api.nvim_buf_get_name(buf_id)] or 0
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

    if M.file_ref_count[file] == nil then
        M.file_ref_count[file] = 1
    else
        M.file_ref_count[file] = M.file_ref_count[file] + 1
    end

    -- M.print_ref_count()
end

M.on_buff_delete = function()
    local buf = vim.api.nvim_win_get_buf(0)
    local file = vim.api.nvim_buf_get_name(buf)

    M.file_ref_count[file] = nil
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

    config.custom_filter = function(buf_number, buf_numbers)
        if M.file_ref_count[vim.api.nvim_buf_get_name(buf_number)] == nil then
            return false
        end

        -- TODO: filter max tab count

        return true
    end

    config.sort_by = function(buffer_a, buffer_b)
        return M.get_ref_count(buffer_a.id) > M.get_ref_count(buffer_b.id)
    end

    return { options = config }
end

--M.setup({})

return M
