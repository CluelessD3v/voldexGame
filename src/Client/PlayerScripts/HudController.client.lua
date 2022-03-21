--# <|=============== SERVICES ===============|>

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--# <|=============== RUNDTIME DATA ===============|>
local WorldEvents               = ReplicatedStorage.Events.WorldRunner
local dragonDied                = WorldEvents.DragonDied
local playerEnteredCurrentLevel = WorldEvents.PlayerEnteredCurrentLevel

local worldData: Folder               = Workspace.WorldData
local dragonLevelObject: NumberValue  = worldData.DragonLevel
local dragonHealthObject: NumberValue = worldData.DragonHealth
local dragonMaxHealthObject: NumberValue    = worldData.DragonMaxHealth
local dragonNameObject : StringValue        = worldData.DragonName

local PlayerGui: PlayerGui = Players.LocalPlayer.PlayerGui 

--
local hud                           = PlayerGui:WaitForChild("HUD")
local dragonStatsFrame: Frame       = hud:WaitForChild("DragonStatsFrame")
local dragonHealthBackground: Frame = dragonStatsFrame:WaitForChild("DragonHealthBackground")
local dragonHealthDisplay: Frame    = dragonHealthBackground:WaitForChild("DragonHealthDisplay")
local healthCounter: TextLabel      = dragonHealthBackground:WaitForChild("HealthCounter")
local dragonNameAndLevel:TextLabel  = dragonStatsFrame:WaitForChild("DragonNameAndLevel")


--# <|=============== RUNDTIME PROCESSES ===============|>

--# Set the HUD as invisible by default
dragonStatsFrame.Visible = false


--# When the player enters the currenet level and 
--# the dragon spawns Show his health, name and level

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

--# When the player kills the level dragon 
--# Hide his health, name and level
dragonDied.OnClientEvent:Connect(function()
    dragonStatsFrame.Visible = false
end)
