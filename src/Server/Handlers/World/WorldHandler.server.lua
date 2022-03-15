--# <|=============== SERVICES ===============|>
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")

--# <|=============== DEPENDENCIES ===============|>
local Entities = ServerScriptService.Entities
local eGoldCoin: ModuleScript     = require(Entities.GoldCoin)
local eDragon: ModuleScript       = require(Entities.Dragon)
local eLootableItem: ModuleScript = require(Entities.LootableItem)

-- Configs
local Configs = ServerScriptService.Configs
local tLootableItems    = require(Configs.LootableItems)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    for type, itemData in pairs(tLootableItems) do
        if CollectionService:HasTag(lootableItem, type) then
            local newLootableItem =  eLootableItem.new(lootableItem, itemData[lootableItem.Name])
            newLootableItem:Start()
        end
    end

end