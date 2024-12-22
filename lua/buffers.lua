local buffers = {}

function buffers.get_path(buf_id)
    local cmd = 'echo expand("#'..tostring(buf_id)..':p")'
    return vim.api.nvim_exec(cmd, true)
end

function buffers.find_by_path(path)
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    local buf_path = buffers.get_path(buf_id)
    local ref_path = vim.fn.fnamemodify(path, ':p') 
    if buf_path == ref_path then
      return buf_id
    end
  end
  return nil
end

return buffers
