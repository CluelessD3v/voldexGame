--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players                = game:GetService("Players")
local CollectionService      = game:GetService("CollectionService")
local ServerScriptService    = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--# <|=============== Dependencies ===============|>
local MapToInstance = require(ReplicatedStorage.MapToInstance)

-- Handlers
local Handlers = ServerScriptService.Handlers

local hPlayerData: ModuleScript      = require(Handlers.PlayerDataHandler)
local hPlayerCombat: ModuleScript    = require(Handlers.PlayerCombatHandler)
local hPlayerInventory: ModuleScript = require(Handlers.PlayerInventoryHandler)

-- Entities
local Entities = ServerScriptService.Entities
-- local eGoldCoin: ModuleScript     = require(Entities.GoldCoin)
local eLootableItem: ModuleScript = require(Entities.LootableItemEntity)

-- Configs
local Configs = ServerScriptService.Configs
local tPlayerDataSchema = require(Configs.PlayerDataSchemaConfig)
local tLootableItems    = require(Configs.LootableItemsConfig)

--- <|=============== PRIVATE FUNCTIONS ===============|>

--* Aux function for lootable item data handling. Checks if the given item has an "item category" tag, 
--* if true then it will return the first value it finds that matches the given lootableItem name
--* (basically, if it has the item type tag, FindFirstKey)

local function GetLootableItemData(lootableItem, lootableItemsList)
    for itemType, itemsTypeTable in pairs(lootableItemsList) do
        if CollectionService:HasTag(lootableItem, itemType) then

            for itemName, itemData in pairs(itemsTypeTable) do
                if lootableItem.Name == itemName then
                    return itemData
                end
            end
        end
    end

    warn("Given Lootable Item does not has a tag that matches given Lootables table key")
    return nil
end

--# <|=============== LOOTABLE ITEMS INTERACTION ===============|>

local function OnLootableOwnerSetBuildIntoBackpack(lootableItem, ownerValue)
    ownerValue.Changed:Connect(function(player: Player)
        local itemDataTable = GetLootableItemData(lootableItem, tLootableItems)
        hPlayerInventory:BuildItemIntoBackpack(player, itemDataTable)
    end)    
    
end


--# Listen for LootableItems Owner ObjectValue changing, if it exist.
--#  if it changes Get LootableItem data from config and call
--#  PlayerInventory handler BuildItemIntoBackpack

--# Listening for new instances being tagged
CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    local ownerValue : ObjectValue = lootableItem:WaitForChild("Owner")

    if ownerValue then
        OnLootableOwnerSetBuildIntoBackpack(lootableItem, ownerValue)
    else
        warn("No OwnerValue was found for LootableItem")
    end
end)

--# iterating already existing ones
for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    local ownerValue : ObjectValue = lootableItem:WaitForChild("Owner")

    if ownerValue then
        OnLootableOwnerSetBuildIntoBackpack(lootableItem, ownerValue)
    else
        warn("No OwnerValue was found for LootableItem")
    end
end

--# <|=============== PLAYER INVENTORY & COMBAT ACTIONS ===============|>
Players.PlayerAdded:Connect(function(player:Player)
    -- player.RespawnLocation = workspace.PlayerSpawnLocation
    local stats: Folder = Instance.new("Folder")
    stats.Name = "stats"
    
    tPlayerDataSchema.ObjectValues.GoldCoins.Parent = player
    hPlayerData:BuildPlayerDataObject(player, tPlayerDataSchema)

    player.CharacterAdded:Connect(function(character)
        CollectionService:AddTag(character, tPlayerDataSchema.MetaData.Tags.DragonTarget)
        hPlayerInventory:TrackWeaponBeingEquipped(character)  
        hPlayerInventory:TrackWeaponBeingUnEquipped(character)

        --*//todo this could be handled by PlayerData
        local startingSword = workspace.Swords.ClassicSword:Clone()

        MapToInstance(startingSword, tLootableItems.SwordType.ClassicSword.ToolItem)
        startingSword.Parent = player.Backpack
    end)


    hPlayerInventory.WeaponEquipped.Event:Connect(function(_, weapon)
        hPlayerCombat.StartCombatMode:FireClient(player, weapon)
    end)

    hPlayerInventory.WeaponUnEquipped.Event:Connect(function(_, weapon)
        print("fired")
        hPlayerCombat.ExitCombatMode:FireClient(player, weapon)
    end)
end)




hPlayerCombat.DamageMob.OnServerEvent:Connect(function(player, mob)
    for _, validTag in ipairs(hPlayerCombat.ValidTargetTags) do
        if CollectionService:HasTag(mob, validTag) then
            local equippedWeapon = hPlayerInventory:GetCharacterCurrentWeapon(player.Character)
            mob.Humanoid.Health -= equippedWeapon:GetAttribute("Damage")
        end
    end
end)
