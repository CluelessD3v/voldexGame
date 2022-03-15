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

function PlayerInventory:TrackIfCharacterEquippedWeapon(character: Model)
    character.ChildAdded:Connect(function(child)
        if CollectionService:HasTag(child, "Weapon") then
            self.WeaponEquipped:Fire(character, child)
        end
    end)
end



return PlayerInventory.new()
