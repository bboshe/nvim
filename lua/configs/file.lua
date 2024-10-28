return {
  oil = {
    opts = {
      default_file_explorer = true,
      columns = { "icon", }, -- "permissions", "size", "mtime",
      skip_confirm_for_simple_edits = true,
      keymaps = require("binds.file").oil.keymaps,
      float = {
        padding = 2,
        max_width = 0,
        max_height = 0,
      },
    }
  }
}
