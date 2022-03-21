--# <|=============== SERVICES ===============|>

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local WorldEvents               = ReplicatedStorage.Events.WorldRunner
local dragonDied                = WorldEvents.DragonDied
local playerEnteredCurrentLevel = WorldEvents.PlayerEnteredCurrentLevel

local worldData: Folder               = Workspace.WorldData
local dragonLevelObject: NumberValue  = worldData.DragonLevel
local dragonHealthObject: NumberValue = worldData.DragonHealth
local dragonMaxHealthObject: NumberValue    = worldData.DragonMaxHealth
local dragonNameObject : StringValue        = worldData.DragonName

local PlayerGui: PlayerGui = Players.LocalPlayer.PlayerGui 

local hud                           = PlayerGui:WaitForChild("HUD")
local dragonStatsFrame: Frame       = hud:WaitForChild("DragonStatsFrame")
local dragonHealthBackground: Frame = dragonStatsFrame:WaitForChild("DragonHealthBackground")
local dragonHealthDisplay: Frame    = dragonHealthBackground:WaitForChild("DragonHealthDisplay")
local healthCounter: TextLabel      = dragonHealthBackground:WaitForChild("HealthCounter")

-- local healthCounter: TextLabel = dragonStatsFrame:WaitForChild("HealthCounter")

local DragonHealthUpdateConn 
dragonStatsFrame.Visible = false

playerEnteredCurrentLevel.OnClientEvent:Connect(function()
    
    DragonHealthUpdateConn = RunService.RenderStepped:Connect(function()
        dragonHealthDisplay.Size = UDim2.fromScale(dragonHealthObject.Value/dragonMaxHealthObject.Value, 1)
        healthCounter.Text = tostring(dragonMaxHealthObject.Value.."/"..dragonHealthObject.Value)
    end)

    dragonStatsFrame.Visible = true

end)


dragonDied.OnClientEvent:Connect(function()
    DragonHealthUpdateConn:Disconnect()
end)
