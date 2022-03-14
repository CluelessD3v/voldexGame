local Inventory = {}
Inventory.__index = Inventory

function Inventory.new()
    local self = setmetatable({}, Inventory)
    return self
end



return Inventory.new()
