--[[
    Main script:
    This is were the core loop of the game is ran, all server handler functions are called from this script
]]

--# <|=============== Services ===============|>
local Players                = game:GetService("Players")
local CollectionService      = game:GetService("CollectionService")
local ServerScriptService    = game:GetService("ServerScriptService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local ServerStorage          = game:GetService("ServerStorage")

--# <|=============== Dependencies ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers
local hPlayerData: ModuleScript      = require(Handlers.PlayerData)
local hPlayerCombat: ModuleScript    = require(Handlers.PlayerCombat)
-- local hPlayerInventory: ModuleScript = require(Handlers.PlayerInventory)

-- Entities
local Entities = ServerScriptService.Entities
-- local eGoldCoin: ModuleScript     = require(Entities.GoldCoin)
-- local eDragon: ModuleScript       = require(Entities.Dragon)
local eLootableItem: ModuleScript = require(Entities.LootableItem)


-- Configs
local Configs = ServerScriptService.Configs
local tPlayerDataSchema = require(Configs.PlayerDataSchema)
local tLootableItems    = require(Configs.LootableItems)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableSword")) do
    local newLootableSword = eLootableItem.new(workspace.ClassicSword, tLootableItems.Swords[lootableItem.Name])
    newLootableSword:Start()
end



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
    end)

    hPlayerCombat.StartCombatMode:FireClient(player)
    task.wait(3)
    hPlayerCombat.ExitCombatMode:FireClient(player)
end)




-- for _, dragon in ipairs(CollectionService:GetTagged("Dragon")) do
--     local newDragon = eDragon.new(dragon)
--     newDragon:Start()
-- end
