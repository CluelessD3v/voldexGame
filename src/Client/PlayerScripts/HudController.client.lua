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
local dragonMaxHealth: NumberValue    = worldData.DragonMaxHealth

local PlayerGui: PlayerGui = Players.LocalPlayer.PlayerGui 
local dragonDataFrame: Frame         = PlayerGui:WaitForChild("DragonDataFrame")
local dragonHealthBar: Frame   = PlayerGui:WaitForChild("DragonHealthBar")
local healthCounter: TextLabel = dragonHealthBar:WaitForChild("HealthCounter")

dragonDataFrame.Visible = false

PlayerEnteredCurrentLevel.OnClientEvent:Connect(function()
    dragonDataFrame.Visible = true

    
end)

DragonDied.OnClientEvent:Connect(function()

end)