--# <|=============== SERVICES ===============|>
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService          = game:GetService("RunService")

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

--# <|=============== LEVEL CONSTRUCTION AND MEDIATION ===============|>

--* Aux function to position current level in front of the previous one
local function PositionCurrLevelInFrontOfPrevLevel(prevLevel: Model, newLevel: Model)
    local currLevel = newLevel
    local theFrontOfThePrevMap    = prevLevel:GetPivot() * CFrame.new(0, 0, (currLevel:GetExtentsSize().Z/-2 +  prevLevel:GetExtentsSize().Z/-2))

    currLevel:PivotTo(theFrontOfThePrevMap)
    return currLevel
end

--# Instancing lobby and first level
local playerEnteredCurrLevel:BindableEvent = Instance.new("BindableEvent")
local lobby  = workspace.Lobby

local numberOfLairs = 0
local prevLevel = lobby
local currLevel = workspace.Lair:Clone()
PositionCurrLevelInFrontOfPrevLevel(prevLevel, currLevel)

numberOfLairs += 1

currLevel.Name = currLevel.Name..numberOfLairs
currLevel.Parent = workspace

--# Stablish first polling that will kickstart Level generation
--# when a valid dragon target is close enough to level activation agro
--# call playerEnteredCurrLevel, then a cyclic behavior will begin

-- local con 
-- con = RunService.Heartbeat:Connect(function() 
--     for _, dragonTarget in ipairs(CollectionService:GetTagged("DragonTarget")) do

--         if (currLevel:GetPivot().Position - dragonTarget:GetPivot().Position).Magnitude <= 50 then
--             print("Entered")
--             playerEnteredCurrLevel:Fire()
--             con:Disconnect()
--         end
--     end

-- end)

for _, v in ipairs(CollectionService:GetTagged("Dragon")) do
    local n = eDragon.new(v)
    n:Start()
    print(v)
    task.wait(1)
    -- n.Instance.Humanoid.Health = 0
end


playerEnteredCurrLevel.Event:Connect(function()
    --# Close level doors here to prevent the player escaping the 
    --# Level bounds
    
    currLevel.SouthDoor.Transparency = 0
    currLevel.SouthDoor.CanCollide = true

    --# Spawn Dragon mesh, and possition him to be at his spawn 
    --# looking at the south door

    local dragonMesh                  = workspace.FrostDragon:Clone()
    local atMobSpawn                  = currLevel.MobSpawn:GetPivot().Position
    local lookingAtSouthDoor          = currLevel.SouthDoor:GetPivot().Position
    local upOffsetToAvoidGettingStuck = Vector3.new(0, dragonMesh:GetExtentsSize().Y/2, 0)

    local currLevelMobSpawn  = CFrame.lookAt(atMobSpawn, lookingAtSouthDoor )
    dragonMesh:PivotTo(currLevelMobSpawn + upOffsetToAvoidGettingStuck)
    
    dragonMesh.Name = "dragon"
    CollectionService:AddTag(dragonMesh, "LootContainer")
    CollectionService:AddTag(dragonMesh, "Dragon")
    dragonMesh.Parent = currLevel

--# ===============|> DRAGON MOBS CONSTRUCTION AND MEDIATION 
    
--# start dragon entity instance state machine

    local newDragonEntity = eDragon.new(dragonMesh)
    newDragonEntity.SpawnLocation = currLevel.MobSpawn
    newDragonEntity:Start()

    --# When mob dies destroy the previous level and create a new one
    --# that will be set as the current level, then position it.

    newDragonEntity.Instance.Humanoid.Died:Connect(function()
        prevLevel:Destroy()
        prevLevel = currLevel
        currLevel = workspace.Lair:Clone()
        PositionCurrLevelInFrontOfPrevLevel(prevLevel, currLevel)
        currLevel.Parent = workspace
        
        --# Create a new run service connection to poll if a valid dragon target 
        --# entered the current level activation agro because the first one to kickstart
        --# this cyclic process no longer exist

        con = RunService.Heartbeat:Connect(function() 
            for _, dragonTarget in ipairs(CollectionService:GetTagged("DragonTarget")) do
        
                if (currLevel:GetPivot().Position - dragonTarget:GetPivot().Position).Magnitude <= 50 then
                    print("Entered")

                    playerEnteredCurrLevel:Fire()
                    con:Disconnect()
                end
            end
        end)
    end)

    -- all connections has been stablished at this point, do testing starting from here
end)


--# <|=============== LOOTABLE_ITEM ENTITIES CONSTRUCTION AND MEDIATION ===============|>

--[[
    Lootable items are created when Instances with the Collection service tag "LootContainer"
    are destroyed.

]]

--* Aux function to construct lootable items from the lootable items config table
local function ConstructLootableItem(lootableItem: PVInstance, configTable: table)
    local lootableItemData = hLootHandler:GetLootableItemConfigFromTable(lootableItem, configTable)
   
    if lootableItemData then
        local newLootableItem  = eLootableItem.new(lootableItem, lootableItemData.DisplayItem)
        newLootableItem:Start()
    else
        warn("No LootableItem Data was found!")
   end
end 


--# Listen for new LootableItem tagged instances being
--# spawned & check for already existing ones to create
--# new LootableItems Entities

CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    ConstructLootableItem(lootableItem, tLootableItems)
end)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    ConstructLootableItem(lootableItem, tLootableItems)    
end

--# Caching all concrete LootableItems configs into a single table,
--# This is so we only have to get all our configs once, so every time
--# A lootableItem needs to be spawned, it fetches from this flat dictionary instead.

local localLootableItemsDict = {}

for _, objectTypeList in pairs(tLootableItems) do
    for objectName, typeObject in pairs(objectTypeList) do
        localLootableItemsDict[objectName] = typeObject
    end
end

--* Aux function to map the basic identifying data to build a new lootable item
--* These data being, the ItemType and ItemName, this is solely here in case the
--* "perch" the item is cloned from DOES NOT has that data already!

local function SpawnLootableItemFromContainerByWeight(lootContainer)
    local lastCF: CFrame = lootContainer:GetPivot()
    print(lootContainer, "Was destroyed")
    
    local selectedItemConfig = hLootHandler:GetItemByWeight(localLootableItemsDict)
    local displayItemConfig = selectedItemConfig.DisplayItem
    
    local newDisplayItemInstance = displayItemConfig.Instance:Clone()
    
    newDisplayItemInstance.Position = lastCF.Position
    newDisplayItemInstance.Parent = workspace
    
    newDisplayItemInstance:SetAttribute("ItemType", displayItemConfig.Attributes.ItemType)
    newDisplayItemInstance:SetAttribute("ItemName", displayItemConfig.Attributes.ItemName)

    CollectionService:AddTag(newDisplayItemInstance, displayItemConfig.Attributes.ItemType)
    CollectionService:AddTag(newDisplayItemInstance, "LootableItem")
end

--# ===============|> LOOT_CONTAINER ENTITIES MEDIATION 

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


