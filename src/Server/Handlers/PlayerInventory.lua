local PlayerInventory = {}
PlayerInventory.__index = PlayerInventory


function PlayerInventory.new()
    local self = setmetatable({}, PlayerInventory)
    return self
end

function PlayerInventory:BuildItemIntoPlayerBackpack(player: Player, theLootedItem: Part | MeshPart, itemData: table)
    if theLootedItem.Name == itemData.Name then
        local newItem: Tool = itemData.ToolInstance:Clone()
        newItem.Parent = player.Backpack
        return 
    end
    warn("The given looted item name does not match any in the given Item list! Failed to build Item")
end

return PlayerInventory.new()
