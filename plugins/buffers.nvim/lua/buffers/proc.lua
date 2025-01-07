local buffers = require("buffers.func")

local process = {}

function process.setup_auto_close()
    local function on_buffer_hidden(event)
        local name = vim.api.nvim_buf_get_name(event.buf)
        print("hide buf: " .. event.buf .. " - " .. name)
        if name ~= "" then 
            return 
        end
        print("del buf: " .. event.buf .. " - " .. name)
        vim.api.nvim_buf_delete(event.buf, { force = true })
    end

    local function on_buffer_hidden(_)
	    for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
            local hidden = not buffers.is_active(buf_id)
            local name = vim.api.nvim_buf_get_name(buf_id)
            print(string.format("buf %d, '%s', %s", buf_id, name, hidden))
            if hidden and name == "" then
				print(string.format("del %d, '%s', %s", buf_id, name, hidden))
                pcall(vim.api.nvim_buf_delete, buf_id, { force = true })
            end
		end
    end

    vim.api.nvim_create_autocmd("BufEnter", { callback = on_buffer_hidden })

    vim.api.nvim_create_autocmd("BufEnter", { callback = function(event)
        print(string.format("BufEnter: %d, %s", event.buf, vim.api.nvim_buf_get_name(event.buf)))
    end})
    vim.api.nvim_create_autocmd("BufLeave", { callback = function(event)
        print(string.format("BufLeave: %d, %s", event.buf, vim.api.nvim_buf_get_name(event.buf)))
    end})
    vim.api.nvim_create_autocmd("BufHidden", { callback = function(event)
        print(string.format("BufHidden: %d, %s", event.buf, vim.api.nvim_buf_get_name(event.buf)))
    end})
    vim.api.nvim_create_autocmd("BufDelete", { callback = function(event)
        print(string.format("BufDelete: %d, %s", event.buf, vim.api.nvim_buf_get_name(event.buf)))
    end})
    vim.api.nvim_create_autocmd("BufWinLeave", { callback = function(event)
        print(string.format("BufWinLeave: %d, %s", event.buf, vim.api.nvim_buf_get_name(event.buf)))
    end})
    vim.api.nvim_create_autocmd("BufWipeout", { callback = function(event)
        print(string.format("BufWipeout: %d, %s", event.buf, vim.api.nvim_buf_get_name(event.buf)))
    end})

end

return process

