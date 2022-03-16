local LootHandler = {}
LootHandler.__index = LootHandler


function LootHandler.new()
    local self = setmetatable({}, LootHandler)
    return self
end



return LootHandler.new()
