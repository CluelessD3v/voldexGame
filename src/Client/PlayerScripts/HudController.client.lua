--# <|=============== SERVICES ===============|>

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WorldEvents               = ReplicatedStorage.Events.WorldRunner
local dragonDied                = WorldEvents.DragonDied
local playerEnteredCurrentLevel = WorldEvents.PlayerEnteredCurrentLevel

local worldData: Folder = Workspace.WorldData
local dragonLevelObject: NumberValue  = worldData.DragonLevel
local dragonHealthObject: NumberValue = worldData.DragonHealth
local dragonMaxHealth: NumberValue    = worldData.DragonMaxHealth

local PlayerGui: PlayerGui = Players.LocalPlayer.PlayerGui 
local hud = PlayerGui:WaitForChild("HUD")
local dragonStatsFrame: Frame      = hud:WaitForChild("DragonStatsFrame")
local dragonHealthBarHolder: Frame = dragonStatsFrame:WaitForChild("DragonHealthBarHolder")
local dragonHealthBar: Frame       = dragonHealthBarHolder:WaitForChild("DragonHealthBar")

-- local healthCounter: TextLabel = dragonStatsFrame:WaitForChild("HealthCounter")

local DragonHealthUpdateConn 

playerEnteredCurrentLevel.OnClientEvent:Connect(function()
    DragonHealthUpdateConn = RunService.RenderStepped:Connect(function()
        dragonHealthBar.Size = UDim2.fromScale(dragonHealthObject.Value/dragonMaxHealth.Value, 1)
    end)
end)


dragonDied.OnClientEvent:Connect(function()
    DragonHealthUpdateConn:Disconnect()
end)
