local LevelHandler = {}
LevelHandler.__index = LevelHandler


function LevelHandler.new()
    local self = setmetatable({}, LevelHandler)
    return self
end




return LevelHandler.new()
