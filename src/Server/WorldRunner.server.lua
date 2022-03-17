--# <|=============== SERVICES ===============|>
local CollectionService   = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local Players             = game:GetService("Players")

--# <|=============== DEPENDENCIES ===============|>
-- Handlers
local Handlers = ServerScriptService.Handlers
local hLootHandler = require(Handlers.LootHandler)

-- Entities
local Entities = ServerScriptService.Entities
local eGoldCoin: ModuleScript     = require(Entities.GoldCoinEntity)
local eDragon: ModuleScript       = require(Entities.DragonEntity)
local eLootableItem: ModuleScript = require(Entities.LootableItemEntity)

-- Configs
local Configs = ServerScriptService.Configs
local tLootableItems    = require(Configs.LootableItemsConfig)

--- <|=============== PRIVATE FUNCTIONS ===============|>

--* Aux function to construct new LootableItem Entities from a list
local function GetLootableItemData(lootableItem, lootableItemsList)
    for itemTypeName, itemsTypeTable in pairs(lootableItemsList) do
        if CollectionService:HasTag(lootableItem, itemTypeName) then
            for itemName, itemData in pairs(itemsTypeTable) do
                if lootableItem.Name == itemName then
                    return itemData
                end
            end
        end
    end
end



--# <|=============== LEVEL CONSTRUCTION ===============|>
local function BuildLair()
    local Lair: Model    = workspace.Lair:Clone()

    local SouthHallway: Part = workspace.Hallway:Clone()
    SouthHallway.Name = "SouthHallway"
    SouthHallway.Parent = Lair

    local shOffset = Lair.PrimaryPart.Size.Z * .5 + SouthHallway.Size.Z * .5
    local shTargetCF = Lair:GetPivot() * CFrame.new(0,0, shOffset)
    SouthHallway:PivotTo(shTargetCF)

    
    local NorthHallway: Model = workspace.Hallway:Clone()
    NorthHallway.Name = "NorthHallway"
    NorthHallway.Parent = Lair

    local nhOffset = Lair.PrimaryPart.Size.Z * -.5 + NorthHallway.Size.Z * -.5
    local nhTargerCF = Lair:GetPivot() * CFrame.new(0, 0 , nhOffset)
    NorthHallway:PivotTo(nhTargerCF)


    return Lair
end

local Lair1 = BuildLair()
Lair1:PivotTo(CFrame.new(0, 100, 0))
Lair1.Parent = workspace

local Lobby: Model = workspace.Lobby
local lbOffset = Lair1.SouthHallway.Size.Z * .5 + Lobby.PrimaryPart.Size.Z * .5
local lbTargetCF = Lair1.SouthHallway:GetPivot() * CFrame.new(0, 0, lbOffset)
Lobby:PivotTo(lbTargetCF)

local Lair2 = BuildLair()
local l2Offset = Lair1.NorthHallway.Size.Z * -.5 + Lair2.PrimaryPart.Size.Z * - .5 + Lair2.SouthHallway.Size.Z * -.5
local l2TargetCF = Lair1.NorthHallway:GetPivot() * CFrame.new(0, 0, l2Offset)
Lair2:PivotTo(l2TargetCF)
Lair2.Parent = workspace


--# <|=============== DRAGON MOBS Handling ===============|>

for _, dragon in ipairs(CollectionService:GetTagged("Dragon")) do
    local animations = dragon.Animations
    local newDragon = eDragon.new(dragon)
    newDragon:Start()
    local animator: Animator = newDragon.Instance.Humanoid.Animator
	newDragon.AnimationTrack = animator:LoadAnimation(animations.Idle)
	
	newDragon.StateChanged.Event:Connect(function(newState)
		print(newState)
		
		if newState == "Homing" or newState == "ChasingPlayer"then
			newDragon.AnimationTrack:Stop()
            newDragon.AnimationTrack = animator:LoadAnimation(animations.Walk)
            newDragon.AnimationTrack:Play()
            
		elseif newState == "Idle" then
			newDragon.AnimationTrack:Stop()
			newDragon.AnimationTrack = animator:LoadAnimation(animations.Idle)
			newDragon.AnimationTrack:Play()

        elseif newState == "Dead" then
            newDragon.AnimationTrack:Stop()
            newDragon.AnimationTrack = animator:LoadAnimation(animations.Death)
            newDragon.AnimationTrack:Play()
        end

    end)
    task.wait(1)
    dragon.Humanoid.Health = 0
end
--# <|=============== LOOTABLE_ITEM ENTITIES CONSTRUCTION AND MEDIATION ===============|>

local function ConstructLootableItem(lootableItem)
    local lootableItemData = GetLootableItemData(lootableItem, tLootableItems)
    local newLootableItem = eLootableItem.new(lootableItem, lootableItemData.DisplayItem)
    newLootableItem:Start()
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

    CollectionService:AddTag(newDisplayItemInstance, displayItemConfig.Attributes.Type)
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

--# <|=============== PLAYER HANDLING ===============|>
--# Each time the player dies he will be sent to the lobby.
Players.PlayerAdded:Connect(function(player)
    -- player.RespawnLocation = workspace.Lobby.SpawnLocation
    player.CharacterAdded:Connect(function(character)
    
    end)

end)

