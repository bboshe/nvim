M = {}

M.file_ref_count = {}

M.reset_ref_count = function() 
    M.file_ref_count = {}
end

M.print_ref_count = function()
    vim.notify(vim.inspect(M.file_ref_count))
--    for file, count in ipairs(M.file_ref_count) do 
--        print(file, count)
end

M.buf_filter = function(buf, file)
    return buf ~= nil and file ~= ""
end

M.on_win_enter = function()
    local buf = vim.api.nvim_win_get_buf(0)
    local file = vim.api.nvim_buf_get_name(buf)
    print(buf, file)
    if not M.buf_filter(buf, file) then 
        return 
    end

    if M.file_ref_count[file] == nil then
        M.file_ref_count[file] = 1
    else
        M.file_ref_count[file] = M.file_ref_count[file] + 1
    end

    M.print_ref_count()
end

M.on_buf_create = function()

end

M.on_buf_delete = function()
end

M.setup = function()
    vim.api.nvim_create_autocmd("BufAdd"   , { callback = M.on_buf_create })
    vim.api.nvim_create_autocmd("BufDelete", { callback = M.on_buf_delete })
    vim.api.nvim_create_autocmd("BufEnter" , { callback = M.on_win_enter  })
end

M.setup()

return M
