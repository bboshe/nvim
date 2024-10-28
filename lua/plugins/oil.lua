return {
  'stevearc/oil.nvim',
  config = function(_, opts)
    local config = require("configs.file").oil
    local binds = require("binds.file").oil
    local oil = require('oil')
    oil.setup(config.opts)
    binds.setup(oil)
  end,
  dependencies = { { "echasnovski/mini.icons", opts = {} } },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
}