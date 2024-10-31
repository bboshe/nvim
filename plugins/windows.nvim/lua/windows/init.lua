local windows = require('windows.windows')
local float   = require('windows.float')

windows.float = float

windows.setup = function(opts)
  -- nothing to do
end

return windows
