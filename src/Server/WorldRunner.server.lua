--# <|=============== SERVICES ===============|>
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")

--# <|=============== DEPENDENCIES ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers
local hLootHandler = require(Handlers.LootHandler)

-- Entities
local Entities = ServerScriptService.Entities
local eGoldCoin: ModuleScript     = require(Entities.GoldCoinEntity)
local eDragon: ModuleScript       = require(Entities.DragonEntity)
local eLootableItem: ModuleScript = require(Entities.LootableItemEntity)
local eLevelEntity:ModuleScript   = require(Entities.LevelEntity)

-- Configs
local Configs = ServerScriptService.Configs
local tLootableItems    = require(Configs.LootableItemsConfig)

--# <|=============== LEVEL CONSTRUCTION AND MEDIATION ===============|>\
local playerEnteredCurrLevel:BindableEvent = Instance.new("BindableEvent")

local lobby  = workspace.Lobby

local prevLevel             = lobby
local prevLevelNorthHallway = prevLevel.NorthHallway
local currLevel             = workspace.Lair:Clone()

local theFrontOfThePrevMap    = prevLevel:GetPivot() * CFrame.new(0, 0, (currLevel:GetExtentsSize().Z/-2 +  prevLevel:GetExtentsSize().Z/-2))
local itsNorthHallwayHalfSize = prevLevelNorthHallway.Size.Z/-2

currLevel:PivotTo(theFrontOfThePrevMap  +  Vector3.new(0, 0, itsNorthHallwayHalfSize))
currLevel.Parent = workspace

playerEnteredCurrLevel.Event:Connect(function()
    
    -- Close level here
        currLevel.SouthDoor.Transparency = 0
        currLevel.SouthDoor.CanCollide = true

    -- spawn dragon here
    local dragonMesh = workspace.FrostDragon:Clone()
    dragonMesh.Name = "FrostDragon1"
    -- dragonMesh:PivotTo(currLevel.MobSpawn:GetPivot() + Vector3.new(0, dragonMesh:GetExtentsSize().Y/2, 0))
    dragonMesh.PrimaryPart.CFrame = CFrame.lookAt(currLevel.MobSpawn:GetPivot().Position + Vector3.new(0, dragonMesh:GetExtentsSize().Y/2, 0), currLevel.SouthDoor.Position)
    CollectionService:AddTag(dragonMesh, "LootContainer")
    CollectionService:AddTag(dragonMesh, "Dragon")
    dragonMesh.Parent = currLevel
    
    -- start battle

    print("Fired")
end)

playerEnteredCurrLevel:Fire()

--# <|=============== DRAGON MOBS CONSTRUCTION AND MEDIATION ===============|>

--! Commented this out since it would attempt to create a new dragon entity after the previous one was created during testing.
-- for _, dragon in ipairs(CollectionService:GetTagged("Dragon")) do
--     print(dragon)
--     -- local newDragon = eDragon.new(dragon)

--     -- newDragon:Start()
--     -- newDragon:SwitchState(newDragon.States.PreparingAttack)
-- end

--# <|=============== LOOTABLE_ITEM ENTITIES CONSTRUCTION AND MEDIATION ===============|>

local function ConstructLootableItem(lootableItem)
    local lootableItemData = hLootHandler:GetLootableItemConfigFromTable(lootableItem, tLootableItems)
   if lootableItemData then
        local newLootableItem  = eLootableItem.new(lootableItem, lootableItemData.DisplayItem)
        newLootableItem:Start()
   else
        warn("No LootableItemData was found!")
   end
end 


--# Listen for new LootableItem tagged instances being
--# spawned & check for already existing ones to create
--# new LootableItems Entities

CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    ConstructLootableItem(lootableItem)
end)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    ConstructLootableItem(lootableItem)    
end



--# <|=============== LOOT_CONTAINER ENTITIES CONSTRUCTION AND MEDIATION ===============|>

--# Caching all concrete LootableItems configs into a single table,
--# This is so we only have to get all our configs once, so every time
--# A lootableItem needs to be spawned, it fetches from this flat dictionary instead.

local localLootableItemsDict = {}

for _, objectTypeList in pairs(tLootableItems) do
    for objectName, typeObject in pairs(objectTypeList) do
        localLootableItemsDict[objectName] = typeObject
    end
end

local function SpawnLootableItemFromContainerByWeight(lootContainer)
    local lastCF: CFrame = lootContainer:GetPivot()
    print(lootContainer, "Was destroyed")
    
    local selectedItemConfig = hLootHandler:GetItemByWeight(localLootableItemsDict)
    local displayItemConfig = selectedItemConfig.DisplayItem
    
    local newDisplayItemInstance = displayItemConfig.Instance:Clone()
    
    newDisplayItemInstance.Position = lastCF.Position
    newDisplayItemInstance.Parent = workspace
    
    newDisplayItemInstance:SetAttribute("ItemType", displayItemConfig.Attributes.ItemType)
    CollectionService:AddTag(newDisplayItemInstance, displayItemConfig.Attributes.ItemType)
    CollectionService:AddTag(newDisplayItemInstance, "LootableItem")
end


for _, lootContainer in ipairs(CollectionService:GetTagged("LootContainer")) do
    lootContainer.Destroying:Connect(function()
        SpawnLootableItemFromContainerByWeight(lootContainer)
    end)
end

CollectionService:GetInstanceAddedSignal("LootContainer"):Connect(function(lootContainer)
    lootContainer.Destroying:Connect(function()
        SpawnLootableItemFromContainerByWeight(lootContainer)
    end)
end)


