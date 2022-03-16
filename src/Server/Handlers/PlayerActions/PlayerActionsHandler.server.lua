--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players                = game:GetService("Players")
local CollectionService      = game:GetService("CollectionService")
local ServerScriptService    = game:GetService("ServerScriptService")


--# <|=============== Dependencies ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers

local hPlayerData: ModuleScript      = require(Handlers.PlayerActions.PlayerData)
local hPlayerCombat: ModuleScript    = require(Handlers.PlayerActions.PlayerCombat)
local hPlayerInventory: ModuleScript = require(Handlers.PlayerActions.PlayerInventory)

-- Entities
local Entities = ServerScriptService.Entities
-- local eGoldCoin: ModuleScript     = require(Entities.GoldCoin)
local eLootableItem: ModuleScript = require(Entities.LootableItem)

-- Configs
local Configs = ServerScriptService.Configs
local tPlayerDataSchema = require(Configs.PlayerDataSchema)
local tLootableItems    = require(Configs.LootableItems)

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

local function CallBuiltItemIntoBackpack(ownerValue, lootableItem, itemDataTable)
    ownerValue.Changed:Connect(function(player: Player)
        hPlayerInventory:BuildItemIntoBackpack(player, lootableItem, itemDataTable[lootableItem.Name])
    end)
end

--+ <|=============== LOOTABLE ITEMS INTERACTION ===============|>

--# Listen for new LootableItems being tagged &
--# Check for already existing ones, for each of them
--# listen for their Owner ObjectValue value property
--# Changing so the Item can be built into the backpack
--# If the OwnerValue does not exist build a new LootableEntity

CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    local itemDataTable = GetLootableItemData(lootableItem, tLootableItems)
    
    local OwnerValue : ObjectValue = lootableItem:WaitForChild("Owner")
    if OwnerValue then
        CallBuiltItemIntoBackpack(OwnerValue, lootableItem, itemDataTable)
        return
    else
        local newLootableItem =  eLootableItem.new(lootableItem, itemDataTable[lootableItem.Name])
        newLootableItem:Start()
        CallBuiltItemIntoBackpack(OwnerValue, lootableItem, itemDataTable)
        return
    end
end)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    local itemDataTable = GetLootableItemData(lootableItem, tLootableItems)
    
    local OwnerValue : ObjectValue = lootableItem:WaitForChild("Owner")
    if OwnerValue then
        CallBuiltItemIntoBackpack(OwnerValue, lootableItem, itemDataTable)
    else
        local newLootableItem =  eLootableItem.new(lootableItem, itemDataTable[lootableItem.Name])
        newLootableItem:Start()
        CallBuiltItemIntoBackpack(OwnerValue, lootableItem, itemDataTable)
    end
end

--+ <|=============== PLAYER INVENTORY & COMBAT ACTIONS ===============|>

Players.PlayerAdded:Connect(function(player:Player)
    player.RespawnLocation = workspace.SpawnLocation
    local stats: Folder = Instance.new("Folder")
    stats.Name = "stats"
    
    tPlayerDataSchema.ObjectValues.GoldCoins.Parent = player
    hPlayerData:BuildPlayerDataObject(player, tPlayerDataSchema)

    print(hPlayerData.PlayerDataObjects)

    -- PlayerDataHandler:SetPlayerDataValue(player, "GoldCoins", 100)
    -- print(PlayerDataHandler:GetPlayerObjectValue(player, "GoldCoins"))

    -- -- PlayerDataHandler:SetPlayerMetaValue(player, "Inventory", {Name = "parapa"})
    -- print(PlayerDataHandler:GetPlayerMetaValue(player, "Inventory"))

    player.CharacterAdded:Connect(function(character)
        CollectionService:AddTag(character, tPlayerDataSchema.MetaData.Tags.DragonTarget)
        hPlayerInventory:TrackWeaponBeingEquipped(character)  
        hPlayerInventory:TrackWeaponBeingUnEquipped(character)

    end)


    hPlayerInventory.WeaponEquipped.Event:Connect(function(_, weapon)
        hPlayerCombat.StartCombatMode:FireClient(player, weapon)
    end)

    hPlayerInventory.WeaponUnEquipped.Event:Connect(function(_, weapon)
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
