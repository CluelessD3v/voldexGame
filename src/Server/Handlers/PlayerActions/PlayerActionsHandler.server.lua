--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players                = game:GetService("Players")
local CollectionService      = game:GetService("CollectionService")
local ServerScriptService    = game:GetService("ServerScriptService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local Workspace = game:GetService("Workspace")
local ServerStorage          = game:GetService("ServerStorage")

--# <|=============== Dependencies ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers
local hWorld = Handlers.World.WorldHandler  --* Mediator Handler

local hPlayerData: ModuleScript      = require(Handlers.PlayerActions.PlayerData)
local hPlayerCombat: ModuleScript    = require(Handlers.PlayerActions.PlayerCombat)
local hPlayerInventory: ModuleScript = require(Handlers.PlayerActions.PlayerInventory)

-- Entities
local Entities = ServerScriptService.Entities
-- local eGoldCoin: ModuleScript     = require(Entities.GoldCoin)
-- local eDragon: ModuleScript       = require(Entities.Dragon)
local eLootableItem: ModuleScript = require(Entities.LootableItem)

-- Configs
local Configs = ServerScriptService.Configs
local tPlayerDataSchema = require(Configs.PlayerDataSchema)
local tLootableItems    = require(Configs.LootableItems)

--- <|=============== PRIVATE FUNCTIONS ===============|>


for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    for type, itemData in pairs(tLootableItems) do
        if CollectionService:HasTag(lootableItem, type) then
            local OwnerValue : ObjectValue = lootableItem:WaitForChild("Owner")
            OwnerValue.Changed:Connect(function(player: Player)
                hPlayerInventory:BuildItemIntoPlayerBackpack(player, lootableItem, itemData[lootableItem.Name])
            end)
        end
    end
end


CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    for type, itemData in pairs(tLootableItems) do
        if CollectionService:HasTag(lootableItem, type) then
            local OwnerValue : ObjectValue = lootableItem:WaitForChild("Owner")
            OwnerValue.Changed:Connect(function(player: Player)
                hPlayerInventory:BuildItemIntoPlayerBackpack(player, lootableItem, itemData[lootableItem.Name])
            end)
        end
    end
end)


Players.PlayerAdded:Connect(function(player:Player)
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
        hPlayerInventory:TrackIfCharacterEquippedWeapon(character)
    end)


    hPlayerInventory.WeaponEquipped.Event:Connect(function(character, weapon)
        print(character, weapon)
    end)

    hPlayerCombat.StartCombatMode:FireClient(player)
    task.wait(3)
    hPlayerCombat.ExitCombatMode:FireClient(player)
end)






-- for _, dragon in ipairs(CollectionService:GetTagged("Dragon")) do
--     local newDragon = eDragon.new(dragon)
--     newDragon:Start()
-- end
