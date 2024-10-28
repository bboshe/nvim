local Path    = require("plenary.path")
local scandir = require("plenary.scandir")

WorkspaceStorage = {}
WorkspaceStorage.__index = WorkspaceStorage

function WorkspaceStorage.get_storage_location()
    return Path:new(vim.fn.stdpath("data"), "workspace")
end

function WorkspaceStorage.get_storage_name(workspace_path)
    local char = "_";
    workspace_path = string.gsub(workspace_path, "/", char)
    workspace_path = string.gsub(workspace_path, "[\\:]", char)
    return workspace_path
end

function WorkspaceStorage.get_storage_path(workspace_path)
    return WorkspaceStorage.get_storage_location() /
        WorkspaceStorage.get_storage_name(workspace_path)
end

function WorkspaceStorage.list_workspaces()
    local files = scandir.scan_dir(WorkspaceStorage.get_storage_location().filename,
                                   { only_dirs = true, depth = 1, hidden = false })
    local result = {}
    for i, file in ipairs(files) do
        local wss = WorkspaceStorage.from_storage(file)
        wss:read_meta_file()
        result[i] = wss
    end
    return result
end

function WorkspaceStorage.from_workspace(workspace_path)
    workspace_path = string.gsub(workspace_path, "/$", "")
    workspace_path = string.gsub(workspace_path, "\\$", "")
    local ws = WorkspaceStorage:new()
    ws.workspace_path = Path:new(workspace_path)
    ws.storage_path   = WorkspaceStorage.get_storage_path(workspace_path)
    return ws
end

function WorkspaceStorage.from_storage(storage_path)
    local ws = WorkspaceStorage:new()
    ws.storage_path = Path:new(storage_path)
    ws:read_meta_file()
    return ws
end

function WorkspaceStorage:new()
    local obj = setmetatable({}, WorkspaceStorage)
    obj.workspace_path = nil
    obj.storage_path   = nil
    obj.last           = nil
    return obj
end

function WorkspaceStorage:valid()
    return not not self.storage_path and self.storage_path:exists()
end

function WorkspaceStorage:load()
    self:read_session()
end

function WorkspaceStorage:write()
    self.storage_path:mkdir({parents=true, exists_ok=true})
    self:write_meta_file()
    self:write_session()
end

function WorkspaceStorage:get_meta_file()
    return self.storage_path / "meta"
end

function WorkspaceStorage:get_session_file()
    return self.storage_path / "session.vim"
end

function WorkspaceStorage:write_meta_file()
    local lines = {}
    table.insert(lines, self.workspace_path.filename)
    table.insert(lines, tostring(os.time()))
    self:get_meta_file():write(table.concat(lines, "\n"), "w")
end

function WorkspaceStorage:read_meta_file()
    local lines = self:get_meta_file():read()
    local lines_iter = lines:gmatch("([^\n]+)")
    self.workspace_path = Path:new(lines_iter())
    self.last           = tonumber(lines_iter())
end

function WorkspaceStorage:write_session()
    vim.cmd('mksession! ' .. self:get_session_file().filename)
end

function WorkspaceStorage:read_session()
    print("sourcing session "..  self:get_session_file().filename)
    vim.cmd('source ' .. self:get_session_file().filename)
end

function WorkspaceStorage:__tostring()
    return string.format("WorkspaceStorage(%s, %d)",
        self.workspace_path.filename,
        self.last or -1)
end

return WorkspaceStorage
