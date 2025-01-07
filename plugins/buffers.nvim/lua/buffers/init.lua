local buffers = {}

function buffers.setup()
    local proc = require("buffers.proc")
    proc.setup_auto_close()
end

return buffers
