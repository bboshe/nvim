local windows = require('windows.windows')

local float = { 
  window = {
    file = {
      line_numbers = true,
      relative_numbers = true,
      width  = { rel = 0.8, min = 80, max = 120 },
      height = { rel = 0.9, min = 30, max = 999 },
    }
  }
}

function float.calc_window_size(screen, cfg)
    local size = math.ceil(screen * cfg.rel)
    if size < cfg.min then size = cfg.min end
    if size > cfg.max then size = cfg.max end
    if size > screen  then size = screen  end
    return size
end

function float.configure_window(opts)
  opts = vim.tbl_deep_extend('force', {
    width  = { rel = 0.5, min = 30, max = 999 },
    height = { rel = 0.7, min = 10, max = 999 }
  }, opts or {})

  local screen_w = vim.opt.columns:get()
  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
  local window_w = float.calc_window_size(screen_w, opts.width)
  local window_h = float.calc_window_size(screen_h, opts.height)
  local pos_x = (screen_w - window_w) / 2
  local pos_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

  return {
    style = "minimal",
    border = 'rounded',
    relative = 'editor',
    row = pos_y,
    col = pos_x,
    width = window_w,
    height = window_h,
  }
end

function float.format_file_name(path)
    -- convert to relative path
    return vim.fn.fnamemodify(path, ":.")
end

function float.close()
  local win_handle = vim.api.nvim_get_current_win()
  if win_handle and windows.is_floating(win_handle) then
    vim.api.nvim_win_close(win_handle, false)
  end
end

function float.open_file(path, opts)
  local temp_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(temp_buf, "bufhidden", "wipe")

  opts = vim.tbl_deep_extend('keep', opts, float.window.file)
  local win_opts = float.configure_window(opts)
  win_opts.title = "[File] " .. float.format_file_name(path)
  local win_handle = vim.api.nvim_open_win(temp_buf, true, win_opts)

  pcall(vim.cmd, "edit " .. path)

  vim.api.nvim_win_set_option(win_handle, "number", float.window.file.line_numbers)
  vim.api.nvim_win_set_option(win_handle, "relativenumber", float.window.file.relative_numbers)

  -- hacky way to ensure normal mode
  vim.api.nvim_feedkeys('\x1B', 'n', false)
end

return float
