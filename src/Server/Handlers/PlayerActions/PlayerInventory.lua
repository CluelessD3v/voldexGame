--[[
    Singleton Class that handles player inventory (Backpack) actions.

]]--

--# <|=============== SERVICES ===============|>
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")

--? <|=============== CONSTRUCTOR ===============|>
local eventsNamespace = ReplicatedStorage.Events.PlayerInventory

local PlayerInventory = {}
PlayerInventory.__index = PlayerInventory


function PlayerInventory.new()
    local self = setmetatable({}, PlayerInventory)
    
    --# Adding Script bindable event for others to listen for
    self.WeaponEquipped = Instance.new("BindableEvent")
    self.WeaponEquipped.Name = "WeaponEquipped"
    self.WeaponEquipped.Parent = script

    self.WeaponUnEquipped = Instance.new("BindableEvent")
    self.WeaponUnEquipped.Name = "WeaponUnEquipped"
    self.WeaponUnEquipped.Parent = script

    return self
end


--* Does a simple 1:1 "conversion" from part/mesh part to a tool, the given looted name MUST match the itemTypeData name field
--* Else the function will not even consider the item

function PlayerInventory:BuildItemIntoPlayerBackpack(player: Player, theLootedItem: Part | MeshPart, toolEquivalentObject: table)
    toolEquivalentObject.Attributes       = toolEquivalentObject.Attributes or {}
    toolEquivalentObject.ToolInstanceTags = toolEquivalentObject.ToolInstanceTags or {}

    if theLootedItem.Name == toolEquivalentObject.Name then
        local newItem: Tool = toolEquivalentObject.ToolInstance:Clone()

        for attName, attVal in pairs(toolEquivalentObject.Attributes) do
            newItem:SetAttribute(attName, attVal)
        end
        
        newItem.Parent = player.Backpack
        return 
    end
    warn("The given looted item name does not match any in the given Item list! Failed to build Item")
end


--[[
    itemTypeData Interface,
    These are the fields the itemTypeData table should have to be able to do a conversion,
    fields marked with a ? are optional:

    Name              : string         = Non unique identifier to match the looted item with the itemTypeData,
    ToolInstanc       : Tool           = Instance reference that the function will clone to the player backpack,
    LootableInstance?: Part | MeshPart = Instance reference that will serve as the "lootable" instance in the workspace
                                         Useful to build a LootableItemEntity!

    Attributes?: table             = table of attributes that can be mapped to both the LootableInstance and the tool instance
    ToolInstanceTagsTags? : table  = table of tags that are mapped to the ToolInstance when it is built
    LootableInstanceTags?: tablle  =  table of tags that are mapped to the LootableInstance when it is constructed 
                                      (LootableItemEntity related)
]]--

--* Fires the WeaponEquipped bindable event when a child with the "Weapon" tag is ADDED to the given character
--* Note that is does not need to be a tool necesarilly, it just needs the "Weapon tag"
function PlayerInventory:TrackWeaponBeingEquipped(character: Model)
    character.ChildAdded:Connect(function(child)
        if CollectionService:HasTag(child, "Weapon") then
            self.WeaponEquipped:Fire(character, child)
        end
    end)
end

--* Fires the WeaponUnEquipped bindable event when a child with the "Weapon" tag is REMOVED from the given character
--* Note that is does not need to be a tool necesarilly, it just needs the "Weapon tag"
function PlayerInventory:TrackWeaponBeingUnEquipped(character: Model)
    character.ChildRemoved:Connect(function(child)
        if CollectionService:HasTag(child, "Weapon") then
            self.WeaponUnEquipped:Fire(character, child)
        end
    end)
end

--* Returns the first child it finds that has the "Weapon" tag
--* Note that is does not need to be a tool necesarilly, it just needs the "Weapon tag"
function PlayerInventory:GetCharacterCurrentWeapon(character: Model)
    for _, child in ipairs(character:GetChildren()) do
        if CollectionService:HasTag(child, "Weapon") then
            return child
        end
    end
end

return PlayerInventory.new()
