--# <|=============== SERVICES ===============|>

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local WorldEvents               = ReplicatedStorage.Events.WorldRunner
local DragonDied                = WorldEvents.DragonDied
local PlayerEnteredCurrentLevel = WorldEvents.PlayerEnteredCurrentLevel

local worldData: Folder = Workspace.WorldData
local dragonLevelObject: NumberValue  = worldData.DragonLevel
local dragonHealthObject: NumberValue = worldData.DragonHealthObject
local dragonMaxHealth: NumberValue = worldData.DragonMaxHealth

local PlayerGui: PlayerGui = Players.LocalPlayer.PlayerGui 
local dataFrame: Frame         = PlayerGui:WaitForChild("DataFrame")
local dragonHealthBar: Frame   = PlayerGui:WaitForChild("DragonHealthBar")
local healthCounter: TextLabel = dragonHealthBar:WaitForChild("HealthCounter")

PlayerEnteredCurrentLevel.OnClientEvent:Connect(function()
    
end)

DragonDied.OnClientEvent:Connect(function()

end)