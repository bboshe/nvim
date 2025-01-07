for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    local listed = vim.fn.bufwinid(buf_id) ~= -1
    --vim.api.nvim_buf_get_option(buf_id, 'buflisted')
    print(tostring(buf_id)..":"..tostring(listed))
end
