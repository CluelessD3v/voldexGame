--# <|=============== SERVICES ===============|>
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local Players             = game:GetService("Players")

--# <|=============== DEPENDENCIES ===============|>
local Entities = ServerScriptService.Entities
local eGoldCoin: ModuleScript     = require(Entities.GoldCoin)
local eDragon: ModuleScript       = require(Entities.Dragon)
local eLootableItem: ModuleScript = require(Entities.LootableItem)

-- Configs
local Configs = ServerScriptService.Configs
local tLootableItems    = require(Configs.LootableItems)

--- <|=============== PRIVATE FUNCTIONS ===============|>

--* Aux function to construct new LootableItem Entities from a list
local function ConstructLootableItemEntityFromList(lootableItem, lootableItemsList)
    for type, itemData in pairs(lootableItemsList) do
        if CollectionService:HasTag(lootableItem, type) then
            local newLootableItem =  eLootableItem.new(lootableItem, itemData[lootableItem.Name])
            newLootableItem:Start()
        end
    end
end

--# Listen for new LootableItem tagged instances being
--# spawned & check for already existing ones to create
--# new LootableItems Entities

CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    ConstructLootableItemEntityFromList(lootableItem, tLootableItems)
end)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    ConstructLootableItemEntityFromList(lootableItem, tLootableItems)
end


--# Each time the player dies he will be sent to the lobby.

Players.PlayerAdded:Connect(function(player)
    player.RespawnLocation = workspace.Lobby.SpawnLocation
    print(player.RespawnLocation)
    
    player.CharacterAdded:Connect(function(character)
    
    
    end)

end)
