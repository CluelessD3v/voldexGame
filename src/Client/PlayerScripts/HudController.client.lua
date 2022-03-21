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
local dragonNameAndLevel:TextLabel  = dragonStatsFrame:WaitForChild("DragonNameAndLevel")

-- local healthCounter: TextLabel = dragonStatsFrame:WaitForChild("HealthCounter")

dragonStatsFrame.Visible = false

playerEnteredCurrentLevel.OnClientEvent:Connect(function()
    dragonNameAndLevel.Text = dragonNameObject.Value.." Level".." "..tostring(dragonLevelObject.Value)
    dragonHealthDisplay.Size = UDim2.fromScale(dragonHealthObject.Value/dragonMaxHealthObject.Value, 1)
    healthCounter.Text = tostring(dragonMaxHealthObject.Value.."/"..dragonHealthObject.Value)

    dragonHealthObject.Changed:Connect(function(newValue)
        dragonHealthDisplay.Size = UDim2.fromScale(newValue/dragonMaxHealthObject.Value, 1)
        healthCounter.Text = tostring(dragonMaxHealthObject.Value.."/"..newValue)
    end)

    dragonStatsFrame.Visible = true

end)


dragonDied.OnClientEvent:Connect(function()
    dragonStatsFrame.Visible = false
end)
