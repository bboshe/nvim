local windows = { }

function windows.is_floating(win)
  local config = vim.api.nvim_win_get_config(win)
  return config.relative ~= ""
end


return windows
