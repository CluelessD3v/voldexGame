local PlayerInventory = {}
PlayerInventory.__index = PlayerInventory


function PlayerInventory.new()
    local self = setmetatable({}, PlayerInventory)
    return self
end

function BuildItemIntoPlayerBackpack(player: Player, theLootedItem: Part | MeshPart, fromItemList: table)
    for _, item in pairs(fromItemList) do
        if theLootedItem.Name == item.Name then
            local newItem: Tool = item.Instance:Clone()
            newItem.Parent = player.Backpack
            return 
        end
    end

    warn("The given looted item name does not match any in the given Item list! Failed to build Item")
end

return PlayerInventory.new()
