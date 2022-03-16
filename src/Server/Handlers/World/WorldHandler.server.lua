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


--+ <|=============== LOOTABLE ITEM ENTITIES CONSTRUCTION ===============|>

--# Listen for new LootableItem tagged instances being
--# spawned & check for already existing ones to create
--# new LootableItems Entities

CollectionService:GetInstanceAddedSignal("LootableItem"):Connect(function(lootableItem)
    ConstructLootableItemEntityFromList(lootableItem, tLootableItems)
end)

for _, lootableItem in ipairs(CollectionService:GetTagged("LootableItem")) do
    ConstructLootableItemEntityFromList(lootableItem, tLootableItems)
end

--+ <|=============== LEVEL CONSTRUCTION ===============|>
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


--+ <|=============== DRAGON MOBS Handling ===============|>

for _, dragon in ipairs(CollectionService:GetTagged("Dragon")) do
    local animations = dragon.Animations
    local newDragon = eDragon.new(dragon)
    newDragon:Start()
    local animator: Animator = newDragon.Instance.Humanoid.Animator
	local animationTrack: AnimationTrack = animator:LoadAnimation(animations.Idle)
	
	newDragon.StateChanged.Event:Connect(function(newState)
		print(newState)
		
		if newState == "Homing" or newState == "ChasingPlayer"then
			animationTrack:Stop()
            animationTrack = animator:LoadAnimation(animations.Walk)
            animationTrack:Play()
            
		elseif newState == "Idle" then
			animationTrack:Stop()
			animationTrack = animator:LoadAnimation(animations.Idle)
			animationTrack:Play()
        end

    end)

end




--+ <|=============== PLAYER HANDLING ===============|>
--# Each time the player dies he will be sent to the lobby.
Players.PlayerAdded:Connect(function(player)
    -- player.RespawnLocation = workspace.Lobby.SpawnLocation
    player.CharacterAdded:Connect(function(character)
    
    end)

end)
