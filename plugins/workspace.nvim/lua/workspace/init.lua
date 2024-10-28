local WorkspaceStorage = require("workspace.storage")
local launch_picker = require("workspace.picker")

WorkspaceManager = {}
WorkspaceManager.show_picker = true
WorkspaceManager.auto_load = false
WorkspaceManager.auto_save = true

function WorkspaceManager.get_workspace_dir ()
    return vim.fn.getcwd()
end

function WorkspaceManager.save_workspace ()
    local ws = WorkspaceStorage.from_workspace(WorkspaceManager.get_workspace_dir())
    ws:write()
    print("workspace written to " .. ws.storage_path.filename)
end

function WorkspaceManager.load_workspace(path, verbose)
    local ws = WorkspaceStorage.from_workspace(path)
    if ws:valid() then
        print("loading workspace " .. ws.storage_path.filename)
        ws:load()
    else
        if verbose then
            vim.api.nvim_echo({{"No saved workspace for "..path, "RedText"}}, true, {})
        end
    end
end

function WorkspaceManager.reload_workspace ()
    WorkspaceManager.load_workspace(WorkspaceManager.get_workspace_dir(), true)
end

function WorkspaceManager.select_workspace ()
    launch_picker(WorkspaceStorage.list_workspaces())
end

function WorkspaceManager.on_vim_enter()
    local current_file_path = vim.fn.expand('%:p')
    if current_file_path == '' then
        if WorkspaceManager.show_picker then
            WorkspaceManager.select_workspace()
        end
    else
        if WorkspaceManager.auto_load then
            -- TODO: bug, happens to early, lsp and highlighting not loaded yet
            WorkspaceManager.load_workspace(current_file_path, false)
        end
    end
end


function WorkspaceManager.setup ()

    local GROUP_NAME = "Workspace"
    vim.api.nvim_create_augroup(GROUP_NAME, { clear = true })
    vim.api.nvim_create_autocmd("VimEnter", { group = GROUP_NAME, callback = WorkspaceManager.on_vim_enter })

    vim.api.nvim_create_user_command('WorkspaceSave'  , WorkspaceManager.save_workspace,   {})
    vim.api.nvim_create_user_command("WorkspaceSelect", WorkspaceManager.select_workspace, {})
    vim.api.nvim_create_user_command("WorkspaceReload", WorkspaceManager.reload_workspace, {})
end

return WorkspaceManager
