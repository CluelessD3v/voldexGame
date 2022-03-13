--[[
    An inventory handler to Read, write operations on the player backpack & StarterPack.

]]--


local Inventory = {}
Inventory.__index = Inventory

--? <|=============== CONSTRUCTOR ===============|>
function Inventory.new()
    local self = setmetatable({}, Inventory)
    return self
end


return Inventory.new()
