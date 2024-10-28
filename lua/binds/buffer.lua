return {
  telescope = {
    setup = function()
      local builtin = require("telescope.builtin")
      vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    end
  },
}
