-- window resizing ------------------------------------------------------------

function win_dims(window)
    local y, x = unpack(vim.api.nvim_win_get_position(window))
    local w = vim.api.nvim_win_get_width(window)
    local h = vim.api.nvim_win_get_height(window)
    return x, y, w, h
end


function win_has_adjacent(window, direction)
    -- TODO: maybe use let wnum = winnr('3k') instead
    local ref_x, ref_y, ref_w, ref_h = win_dims(window)
    local all_wins = vim.api.nvim_tabpage_list_wins(0)
    for _, h_win in pairs(all_wins) do
        local x, y, _, _ = win_dims(h_win)
        if direction == 'right' then
            if ref_x + ref_w < x then
                return true
            end
        elseif direction == 'up' then
            if ref_x == x and ref_y > y then
                return true
            end
        else
            error("unkown direction")
        end
    end
    return false
end


function resize_window(win, increase, horizontal)
    local delta = 2 * ((increase) and 1 or -1)
    if horizontal then
        local old_width = vim.api.nvim_win_get_width(win)
        vim.api.nvim_win_set_width(win, old_width + delta)
    else
        local old_height = vim.api.nvim_win_get_height(win)
        vim.api.nvim_win_set_height(win, old_height + delta)
    end
    vim.cmd("redraw!")
end


function resize_window_handler(horizontal, right)
    local win = vim.api.nvim_get_current_win()
    local dirtab = {[true]='right',[false]='up'}
    local adj = win_has_adjacent(win, dirtab[horizontal])
    local incr = (adj == horizontal) == right
    resize_window(win, incr, horizontal)
end


function window_resize_mode()
    vim.cmd([[echo "--RESIZE--"]])
    while true do
        local char = vim.fn.nr2char(vim.fn.getchar())
        if char == '\27' then  -- Check for Escape key
            break
        elseif char == 'h' then
            resize_window_handler(true, false)
        elseif char == 'l' then
            resize_window_handler(true, true)
        elseif char == 'j' then
            resize_window_handler(false, true)
        elseif char == 'k' then
            resize_window_handler(false, false)
        end
    end
    vim.api.nvim_feedkeys(':', 'nx', true)
end


-- floating window -------------------------------------------------------------

peak_window = {
    relative_height = 0.8,
    relative_width  = 0.8,
    handle          = nil,
    create = function()
        if peak_window.handle then
            print("Another float window is already opened!")
            return
        end

        local buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

        local width = vim.api.nvim_get_option("columns")
        local height = vim.api.nvim_get_option("lines")

        local win_height = math.ceil(height * peak_window.relative_height - 4)
        local win_width = math.ceil(width * peak_window.relative_width)

        local row = math.ceil((height - win_height) / 2 - 1)
        local col = math.ceil((width - win_width) / 2)

        local opts = {
            style = "minimal",
            relative = "editor",
            width = win_width,
            height = win_height,
            row = row,
            col = col,
            border = "rounded",
        }

        peak_window.handle = vim.api.nvim_open_win(buf, true, opts)
    end,
    close = function()
        if peak_window.handle and peak_window.handle == vim.api.nvim_get_current_win() then
            vim.api.nvim_win_close(peak_window.handle, false)
            peak_window.handle = nil
        end
    end
}

vim.api.nvim_create_autocmd("WinLeave", { callback = peak_window.close })
vim.keymap.set('n', '<ESC>', peak_window.close, { })
vim.api.nvim_create_user_command('Peak', function() peak_window.create() end, {})



