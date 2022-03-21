--# <|=============== SERVICES ===============|>
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local RunService          = game:GetService("RunService")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--# <|=============== DEPENDENCIES ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers
local hLootHandler = require(Handlers.LootHandler)
local hPlayerDataHandler = require(Handlers.PlayerDataHandler)

-- Entities
local Entities = ServerScriptService.Entities
local eGoldCoin: ModuleScript     = require(Entities.GoldCoinEntity)
local eDragon: ModuleScript       = require(Entities.DragonEntity)
local eLootableItem: ModuleScript = require(Entities.LootableItemEntity)
local eLevelEntity:ModuleScript   = require(Entities.LevelEntity)

-- Configs
local Configs = ServerScriptService.Configs
local tLootableItems    = require(Configs.LootableItemsConfig)
local tFrostDragon  = require(Configs.Dragons.FrostDragonConfig)


-- Remote Events
local WorldEvents                     = ReplicatedStorage.Events.WorldRunner
local playerEnteredCurrentLevelRemote = WorldEvents.PlayerEnteredCurrentLevel
local DragonDiedRemote                = WorldEvents.DragonDied

--# <|=============== LEVEL CONSTRUCTION AND MEDIATION ===============|>
--# Instancing lobby and first level
local WorldData = workspace.WorldData
local playerEnteredCurrLevel:BindableEvent = Instance.new("BindableEvent")
local lobby  = workspace.Lobby

local currentLevelPlayerIs = 0      --# Used for difculty scalling value of the dragon
local prevLevel = lobby  --# The first prev level is the lobby
local currLevel = workspace.Level:Clone()
currLevel.Name = currLevel.Name..currentLevelPlayerIs
currLevel.Parent = workspace


--* Aux function to position current level in front of the previous one
local function PositionCurrLevelInFrontOfPrevLevel(previousLevel: Model, newLevel: Model)
    local currentLevel = newLevel
    local theFrontOfThePrevMap    = previousLevel:GetPivot() * CFrame.new(0, 0, (currentLevel:GetExtentsSize().Z/-2 +  prevLevel:GetExtentsSize().Z/-2))

    currentLevel:PivotTo(theFrontOfThePrevMap)
    return currentLevel
end

local function DidPlayerEnteredCurrLevel(currentLevel, levelAgro)
    for _, dragonTarget in ipairs(CollectionService:GetTagged("DragonTarget")) do

        if (currentLevel:GetPivot().Position - dragonTarget:GetPivot().Position).Magnitude <= levelAgro then
            local playerWhoEntered = Players:GetPlayerFromCharacter(dragonTarget)

            if playerWhoEntered then
                print("player entered level")
                currentLevelPlayerIs += 1

                 --# Let know the client he entered the current level.
                playerEnteredCurrentLevelRemote:FireClient(playerWhoEntered)
                
                --# Let know the world runner a player entered the curr level
                playerEnteredCurrLevel:Fire(playerWhoEntered)
                return true
            end
        end
    end
end


--# Position current level in front of previous one (which would be the lobby, this early)
PositionCurrLevelInFrontOfPrevLevel(prevLevel, currLevel)

--# Stablish first polling that will kickstart Level generation
--# when a valid dragon target is close enough to level activation agro
--# call playerEnteredCurrLevel, then a cyclic behavior will begin

-- local PlayerEnteredLevelPoll 
-- PlayerEnteredLevelPoll = RunService.Heartbeat:Connect(function() 
--     if DidPlayerEnteredCurrLevel(currLevel, 100) then
--         PlayerEnteredLevelPoll:Disconnect()
--     end
-- end)


for _, v in pairs(CollectionService:GetTagged("Dragon")) do
    local n = eDragon.new(v, tFrostDragon)
    n.StatsScalling = 3
    n:Start()

    task.wait(1)
    -- n:SwitchState(n.States.Idle)
    n.Instance.Humanoid.Health = 0
end

playerEnteredCurrLevel.Event:Connect(function(playerWhoEntered)
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
    
    dragonMesh.Name = "FrostDragon"
    CollectionService:AddTag(dragonMesh, "LootContainer")
    CollectionService:AddTag(dragonMesh, "Dragon")
    dragonMesh.Parent = currLevel

--# ===============|> DRAGON MOBS CONSTRUCTION AND MEDIATION 
    
    --# Construct new dragon 

    local newDragonEntity = eDragon.new(dragonMesh)
    newDragonEntity.SpawnLocation   = currLevel.MobSpawn
    newDragonEntity.StatScaling     = currentLevelPlayerIs

    --# World data to feed GUI
    WorldData.DragonHealth.Value    = newDragonEntity.Instance.Humanoid.Health
    WorldData.DragonMaxHealth.Value = newDragonEntity.Instance.Humanoid.MaxHealth
    WorldData.DragonLevel.Value     = currentLevelPlayerIs

    newDragonEntity.Instance.Humanoid.HealthChanged:Connect(function(newVal)
        WorldData.DragonHealth.Value = newVal
    end)

    newDragonEntity:Start()

    --# When mob dies destroy the previous level and create a new one
    --# that will be set as the current level, then position it.

    newDragonEntity.Instance.Humanoid.Died:Connect(function()
        prevLevel:Destroy()
        prevLevel = currLevel
        currLevel = workspace.Level:Clone()
        PositionCurrLevelInFrontOfPrevLevel(prevLevel, currLevel)
        currLevel.Parent = workspace

        DragonDiedRemote:FireClient(playerWhoEntered)

        local clearedLevels = hPlayerDataHandler:GetPlayerObjectValue(playerWhoEntered, "ClearedLevels")
        hPlayerDataHandler:SetPlayerDataValue(playerWhoEntered, "ClearedLevels", clearedLevels.Value + 1)
        
        --# Create a new run service connection to poll if a valid dragon target 
        --# entered the current level activation agro because the first one to kickstart
        --# this cyclic process no longer exist

        PlayerEnteredLevelPoll = RunService.Heartbeat:Connect(function() 
            if DidPlayerEnteredCurrLevel(currLevel, 100) then
                PlayerEnteredLevelPoll:Disconnect()
            end
        end)
    end)
end)

--# <|=============== GoldCoins ENTITIES CONSTRUCTION AND MEDIATION ===============|>
--# Cache Dragon config tables so we have access to them
--# to deremine how many coins we should drop for the player
local dragonConfigs = ServerScriptService.Configs.Dragons:GetChildren()
local cachedDragonConfigs = {}
local coinSpawningRadius = 5 

for _, dragonConfig in pairs(dragonConfigs) do
    cachedDragonConfigs[dragonConfig.Name] = require(dragonConfig)
end

local function OnDragonDestroyedSpawnCoins(dragonInstance: Model, dragonConfigsList)
    for _, dragonConfig in pairs(dragonConfigsList) do
        if dragonInstance.Name == dragonConfig.Name then
            local lastCF = dragonInstance:GetPivot()
            local baseGoldCoinsDropped = dragonConfig.BaseGoldCoinsDropped
            local maxGoldCoinsDropped = dragonConfig.MaxGoldCoinsDropped
            
            for _ = 1, math.random(baseGoldCoinsDropped, maxGoldCoinsDropped)do
                local coin = workspace.Coin:Clone()
                coin:PivotTo(lastCF)
                coin.PrimaryPart.CanCollide = false
                coin.Parent = currLevel

                local goal = {CFrame = lastCF + Vector3.new(math.random(0, coinSpawningRadius), 0, math.random(0, coinSpawningRadius))}
                local info = TweenInfo.new(
                    .5,
                    Enum.EasingStyle.Circular,
                    Enum.EasingDirection.Out,
                    0,
                    false,
                    0
                )

                CollectionService:AddTag(coin, "GoldCoin")
                local tween = TweenService:Create(coin.PrimaryPart, info, goal)
                tween:Play()
            end	
        else
            warn("Dragon instance name does not match that of the config!")
        end
    end

end


--# When the dragon humanoid instance health reaches 0
--# Spawn the between [BaseGoldCoinsDropped, MaxGoldCoinsDropped] coins

--> GO through ones that might already exist
for _, dragonInstance in ipairs(CollectionService:GetTagged("Dragon")) do
    dragonInstance.Humanoid.Died:Connect(function()
        OnDragonDestroyedSpawnCoins(dragonInstance, cachedDragonConfigs)
    end)

end
--> Listen for new ones that might get tagged
CollectionService:GetInstanceAddedSignal("Dragon"):Connect(function(dragonInstance:Model)
    dragonInstance.Humanoid.Died:Connect(function()
        OnDragonDestroyedSpawnCoins(dragonInstance, cachedDragonConfigs)
    end)
end)


CollectionService:GetInstanceAddedSignal("GoldCoin"):Connect(function(goldCoinInstance)
    print(goldCoinInstance)
    local newGoldCoin = eGoldCoin.new(goldCoinInstance)
    newGoldCoin:Init()
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

local cachedLootablesItems = {}

for _, objectTypeList in pairs(tLootableItems) do
    for objectName, objectData in pairs(objectTypeList) do
        --# ommit non lootable itmes i.e starting sword
        --# (yeah, a bit contradicting to original intent)

        if objectData.Lootable == true then
            cachedLootablesItems[objectName] = objectData
        end
    end
end

--* Aux function to map the basic identifying data to build a new lootable item
--* These data being, the ItemType and ItemName, this is solely here in case the
--* "perch" the item is cloned from DOES NOT has that data already!

local function SpawnLootableItemFromContainerByWeight(lootContainer, lootablesList)
        local lastCF: CFrame = lootContainer:GetPivot()
        print(lootContainer, "Was destroyed")
        
        local selectedItemConfig = hLootHandler:GetItemByWeight(lootablesList)
        local displayItemConfig = selectedItemConfig.DisplayItem
        
        local newDisplayItemInstance = displayItemConfig.Instance:Clone()
        
        newDisplayItemInstance.Position = lastCF.Position
        newDisplayItemInstance.Parent   = workspace
        
        newDisplayItemInstance:SetAttribute("ItemType", displayItemConfig.Attributes.ItemType)
        newDisplayItemInstance:SetAttribute("ItemName", displayItemConfig.Attributes.ItemName)

        CollectionService:AddTag(newDisplayItemInstance, displayItemConfig.Attributes.ItemType)
        CollectionService:AddTag(newDisplayItemInstance, "LootableItem")
end

--# ===============|> LOOT_CONTAINER ENTITIES MEDIATION 

--# Pick through a weighted choice the item that will be dropped to the player for killing the dragon
--# Note, this not done when the loot container "humanoid" dies because
--# ideally not all loot containers are humanoids!

for _, lootContainer in ipairs(CollectionService:GetTagged("LootContainer")) do
    lootContainer.Destroying:Connect(function()
        SpawnLootableItemFromContainerByWeight(lootContainer, cachedLootablesItems)
    end)
end

CollectionService:GetInstanceAddedSignal("LootContainer"):Connect(function(lootContainer)
    lootContainer.Destroying:Connect(function()
        SpawnLootableItemFromContainerByWeight(lootContainer, cachedLootablesItems)
    end)
end)


