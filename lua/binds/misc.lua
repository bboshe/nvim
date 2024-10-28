return {
  setup = function() 
    -- Workspace ------------------------------------------
    local workspace_prefix = '<leader>z'

    vim.keymap.set('n', workspace_prefix..'g', function() 
        vim.cmd("WorkspaceSelect")
    end, { })

    vim.keymap.set('n', workspace_prefix..'r', function() 
        vim.cmd("WorkspaceReload")
    end, { })

    vim.keymap.set('n', workspace_prefix..'s', function() 
        vim.cmd("WorkspaceSave")
    end, { })

    vim.keymap.set('n', workspace_prefix..'q', function() 
        vim.cmd("WorkspaceSave")
        vim.cmd("qall")
    end, { })
  end
}
