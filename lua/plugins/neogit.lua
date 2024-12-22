local function encode(str) 
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local function toggle()
    vim.api.nvim_feedkeys(encode("<tab>"), 'm', false)
end


return {
      "NeogitOrg/neogit",
      dependencies = {
            "nvim-lua/plenary.nvim",         -- required
            "sindrets/diffview.nvim",        -- optional - Diff integration
            "nvim-telescope/telescope.nvim", -- optional
          },
      config = function()
        require("neogit").setup({

        mappings = {
            popup = {
                ["l"] = false,
                ["L"] = "LogPopup",
            },
            status = {
                ["l"] = toggle,
                ["h"] = toggle,
            },
        },
      }
        )
        end
    }
